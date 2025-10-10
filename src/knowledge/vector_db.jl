"""
    VectorDatabase Integration for DataMind Knowledge Graph

Enhanced semantic search capabilities using vector embeddings alongside Neo4j graph structure.
"""

using HTTP, JSON3, Statistics, Dates
using LinearAlgebra: dot, norm

# Try to load optional vector database dependencies
try
    using PyCall
    global CHROMA_AVAILABLE = true
    global chroma = pyimport("chromadb")
catch
    global CHROMA_AVAILABLE = false
    @warn "ChromaDB not available - vector database features disabled"
end

"""
    VectorDatabase

Abstract interface for vector database operations.
"""
abstract type VectorDatabase end

"""
    ChromaVectorDB

Chroma database implementation for local vector storage.
"""
mutable struct ChromaVectorDB <: VectorDatabase
    client
    collections::Dict{String, Any}
    embedding_dimension::Int
    
    function ChromaVectorDB()
        if !CHROMA_AVAILABLE
            error("ChromaDB not available. Install with: pip install chromadb")
        end
        
        # Create persistent storage directory
        persist_path = joinpath(homedir(), ".dsassist", "chromadb")
        if !isdir(persist_path)
            mkpath(persist_path)
            @info "Created ChromaDB storage directory: $persist_path"
        end
        
        # Use PersistentClient for cross-session storage
        client = chroma.PersistentClient(path=persist_path)
        @info "ChromaDB persistent client initialized at: $persist_path"
        
        collections = Dict{String, Any}()
        
        # Initialize collections for different data types
        try
            collection_names = ["research_questions", "code_patterns", "experiment_results", "agent_communications"]
            for name in collection_names
                try
                    # Try to get existing collection first
                    collections[name] = client.get_collection(name=name)
                    @info "Loaded existing ChromaDB collection: $name"
                catch
                    # Create new collection if it doesn't exist
                    collections[name] = client.create_collection(name=name)
                    @info "Created new ChromaDB collection: $name"
                end
            end
            
            @info "ChromaDB collections initialized successfully"
        catch e
            @warn "ChromaDB collection initialization failed" error=e
        end
        
        new(client, collections, 128)  # Use 128-dimensional embeddings for compatibility
    end
end

"""
    InMemoryVectorDB

Simple in-memory vector database for fallback when external databases unavailable.
"""
mutable struct InMemoryVectorDB <: VectorDatabase
    embeddings::Dict{String, Dict{String, Any}}
    embedding_dimension::Int
    
    function InMemoryVectorDB(dimension::Int=1536)
        new(Dict{String, Dict{String, Any}}(), dimension)
    end
end

"""
    EnhancedKnowledgeGraph

Knowledge graph with integrated vector database for semantic search.
"""
mutable struct EnhancedKnowledgeGraph
    neo4j_backend::Union{Neo4jKnowledgeGraph, Nothing}
    vector_db::Union{VectorDatabase, Nothing}
    in_memory_kg::KnowledgeGraph
    embedding_cache::Dict{String, Vector{Float64}}
    
    function EnhancedKnowledgeGraph(kg::KnowledgeGraph)
        # Try to initialize vector database
        vector_db = try
            ChromaVectorDB()
        catch e
            @warn "Falling back to in-memory vector database" error=e
            InMemoryVectorDB()
        end
        
        new(kg.neo4j_backend, vector_db, kg, Dict{String, Vector{Float64}}())
    end
end

"""
    get_text_embedding(text::String; model::String="simple")

Get embedding for text using available embedding methods.
"""
function get_text_embedding(text::String; model::String="simple")
    if model == "simple"
        # Simple bag-of-words embedding for fallback
        return simple_text_embedding(text)
    elseif model == "openai" && haskey(ENV, "OPENAI_API_KEY")
        # Use OpenAI embeddings if available
        return get_openai_embedding(text)
    else
        # Fallback to simple embedding
        return simple_text_embedding(text)
    end
end

"""
    simple_text_embedding(text::String; dimension::Int=128)

Simple bag-of-words based embedding for testing and fallback.
"""
function simple_text_embedding(text::String; dimension::Int=128)
    # Normalize text
    words = split(lowercase(text), r"[^a-zA-Z0-9]+")
    filter!(w -> length(w) > 2, words)  # Remove short words
    
    # Create simple hash-based embedding
    embedding = zeros(Float64, dimension)
    
    for word in words
        # Simple hash function for word positioning
        hash_val = hash(word) % dimension + 1
        embedding[hash_val] += 1.0
    end
    
    # L2 normalize
    norm_val = norm(embedding)
    if norm_val > 0
        embedding ./= norm_val
    end
    
    return embedding
end

"""
    get_openai_embedding(text::String; model::String="text-embedding-ada-002")

Get OpenAI embedding for text (requires API key).
"""
function get_openai_embedding(text::String; model::String="text-embedding-ada-002")
    api_key = get(ENV, "OPENAI_API_KEY", "")
    if isempty(api_key)
        @warn "OPENAI_API_KEY not found, falling back to simple embedding"
        return simple_text_embedding(text, 1536)
    end
    
    try
        response = HTTP.post(
            "https://api.openai.com/v1/embeddings",
            headers=[
                "Authorization" => "Bearer $api_key",
                "Content-Type" => "application/json"
            ],
            body=JSON3.write(Dict(
                "model" => model,
                "input" => text
            ))
        )
        
        result = JSON3.read(response.body)
        return Vector{Float64}(result.data[1].embedding)
        
    catch e
        @warn "OpenAI embedding request failed, falling back to simple embedding" error=e
        return simple_text_embedding(text, 1536)
    end
end

"""
    embed_research_question(ekg::EnhancedKnowledgeGraph, question::String, experiment_id::String)

Create and store embedding for research question.
"""
function embed_research_question(ekg::EnhancedKnowledgeGraph, question::String, experiment_id::String)
    # Check cache first
    cache_key = "research_$experiment_id"
    if haskey(ekg.embedding_cache, cache_key)
        return ekg.embedding_cache[cache_key]
    end
    
    # Generate embedding
    embedding = get_text_embedding(question)
    ekg.embedding_cache[cache_key] = embedding
    
    # Store in vector database
    if ekg.vector_db isa ChromaVectorDB && CHROMA_AVAILABLE
        try
            collection = ekg.vector_db.collections["research_questions"]
            collection.add(
                embeddings=[embedding],
                documents=[question],
                ids=[experiment_id],
                metadatas=[Dict("type" => "research_question", "timestamp" => string(Dates.now()))]
            )
        catch e
            @warn "Failed to store in ChromaDB" error=e
        end
    elseif ekg.vector_db isa InMemoryVectorDB
        # Store in in-memory database
        ekg.vector_db.embeddings[experiment_id] = Dict(
            "embedding" => embedding,
            "text" => question,
            "type" => "research_question",
            "timestamp" => Dates.now()
        )
    end
    
    return embedding
end

"""
    cosine_similarity(a::Vector{Float64}, b::Vector{Float64})

Calculate cosine similarity between two vectors.
"""
function cosine_similarity(a::Vector{Float64}, b::Vector{Float64})
    if length(a) != length(b)
        return 0.0
    end
    
    norm_a = norm(a)
    norm_b = norm(b)
    
    if norm_a == 0.0 || norm_b == 0.0
        return 0.0
    end
    
    return dot(a, b) / (norm_a * norm_b)
end

"""
    semantic_similarity_search(ekg::EnhancedKnowledgeGraph, query::String; k::Int=5, min_similarity::Float64=0.5)

Perform semantic similarity search for research questions.
"""
function semantic_similarity_search(ekg::EnhancedKnowledgeGraph, query::String; k::Int=5, min_similarity::Float64=0.5)
    query_embedding = get_text_embedding(query)
    results = []
    
    if ekg.vector_db isa ChromaVectorDB && CHROMA_AVAILABLE
        # Use ChromaDB similarity search
        try
            collection = ekg.vector_db.collections["research_questions"]
            chroma_results = collection.query(
                query_embeddings=[query_embedding],
                n_results=k,
                include=["documents", "distances", "metadatas"]
            )
            
            # Convert ChromaDB results to our format
            if haskey(chroma_results, "ids") && size(chroma_results["ids"], 2) > 0
                ids = chroma_results["ids"]
                distances = get(chroma_results, "distances", Matrix{Float64}(undef, 1, 0))
                documents = get(chroma_results, "documents", Matrix{String}(undef, 1, 0))
                metadatas = get(chroma_results, "metadatas", Matrix{Dict{Any,Any}}(undef, 1, 0))
                
                # ChromaDB 1.1+ returns matrices, access as [1, i] for each result
                for i in 1:size(ids, 2)
                    id = ids[1, i]
                    distance = size(distances, 2) >= i ? distances[1, i] : 1.0
                    similarity = 1.0 - distance  # ChromaDB returns distance, convert to similarity
                    document = size(documents, 2) >= i ? documents[1, i] : ""
                    metadata = size(metadatas, 2) >= i ? metadatas[1, i] : Dict()
                    
                    if similarity >= min_similarity
                        push!(results, (
                            experiment_id=id,
                            similarity=similarity,
                            text=document,
                            metadata=metadata
                        ))
                    end
                end
            end
        catch e
            @warn "ChromaDB search failed, falling back to in-memory search" error=e
            # Clear results to trigger fallback
            results = []
        end
    end
    
    # Fallback to in-memory search if ChromaDB failed or not available
    if isempty(results) && ekg.vector_db isa InMemoryVectorDB
        for (exp_id, data) in ekg.vector_db.embeddings
            if data["type"] == "research_question"
                similarity = cosine_similarity(query_embedding, data["embedding"])
                if similarity >= min_similarity
                    push!(results, (
                        experiment_id=exp_id,
                        similarity=similarity,
                        text=data["text"],
                        metadata=get(data, "metadata", Dict())
                    ))
                end
            end
        end
    end
    
    # Sort by similarity (highest first)
    sort!(results, by=x->x.similarity, rev=true)
    
    return results
end

"""
    enhanced_query_insights(ekg::EnhancedKnowledgeGraph, research_question::String; k::Int=5)

Enhanced version of query_insights using both semantic and structural search.
"""
function enhanced_query_insights(ekg::EnhancedKnowledgeGraph, research_question::String; k::Int=5)
    insights = []
    
    # 1. Semantic similarity search
    semantic_results = semantic_similarity_search(ekg, research_question, k=k*2)  # Get more candidates
    
    # 2. Combine with graph-based insights if available
    if ekg.neo4j_backend !== nothing
        try
            # Get traditional graph-based insights
            graph_insights = query_insights(ekg.in_memory_kg, research_question)
            
            # Merge and deduplicate results
            for result in semantic_results
                # Add semantic score to graph insights if experiment exists in both
                graph_match = findfirst(x -> get(x, "experiment_id", "") == result.experiment_id, graph_insights)
                if graph_match !== nothing
                    graph_insights[graph_match]["semantic_similarity"] = result.similarity
                    graph_insights[graph_match]["combined_score"] = 0.7 * result.similarity + 0.3 * get(graph_insights[graph_match], "relevance_score", 0.5)
                else
                    # Add new semantic result
                    push!(graph_insights, Dict(
                        "experiment_id" => result.experiment_id,
                        "research_question" => result.text,
                        "semantic_similarity" => result.similarity,
                        "source" => "semantic_search",
                        "combined_score" => result.similarity
                    ))
                end
            end
            
            # Sort by combined score
            sort!(graph_insights, by=x -> get(x, "combined_score", 0.0), rev=true)
            insights = graph_insights[1:min(k, length(graph_insights))]
            
        catch e
            @warn "Graph-based search failed, using semantic results only" error=e
            insights = [Dict(
                "experiment_id" => r.experiment_id,
                "research_question" => r.text,
                "semantic_similarity" => r.similarity,
                "source" => "semantic_only"
            ) for r in semantic_results[1:min(k, length(semantic_results))]]
        end
    else
        # Use semantic results only
        insights = [Dict(
            "experiment_id" => r.experiment_id,
            "research_question" => r.text,
            "semantic_similarity" => r.similarity,
            "source" => "semantic_only"
        ) for r in semantic_results[1:min(k, length(semantic_results))]]
    end
    
    return insights
end

"""
    initialize_vector_knowledge_graph(kg::KnowledgeGraph)

Initialize enhanced knowledge graph with vector database capabilities.
"""
function initialize_vector_knowledge_graph(kg::KnowledgeGraph)
    @info "Initializing enhanced knowledge graph with vector database support"
    ekg = EnhancedKnowledgeGraph(kg)
    
    # Test the system
    if ekg.vector_db !== nothing
        @info "Vector database initialized successfully"
        
        # Test embedding
        test_embedding = get_text_embedding("test query for embedding system")
        @info "Embedding system working" embedding_dimension=length(test_embedding)
    else
        @warn "Vector database initialization failed - using graph-only mode"
    end
    
    return ekg
end

# Export enhanced functions
export EnhancedKnowledgeGraph, initialize_vector_knowledge_graph, 
       enhanced_query_insights, semantic_similarity_search,
       embed_research_question, get_text_embedding