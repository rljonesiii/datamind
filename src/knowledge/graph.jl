"""
    KnowledgeGraph

Maintains experiment provenance and learning history.
Supports both in-memory storage and Neo4j database backends.
"""

import Statistics

# Include Neo4j implementation
include("neo4j_graph.jl")

mutable struct KnowledgeGraph
    nodes::Dict{String, Dict{String, Any}}
    edges::Vector{Dict{String, Any}}
    experiments::Dict{String, Any}
    neo4j_backend::Union{Neo4jKnowledgeGraph, Nothing}
    
    function KnowledgeGraph()
        # Try to create Neo4j backend if configured
        neo4j_kg = create_neo4j_knowledge_graph()
        
        if neo4j_kg !== nothing
            try
                initialize_schema(neo4j_kg)
                @info "Using Neo4j knowledge graph backend"
            catch e
                @warn "Failed to initialize Neo4j, falling back to in-memory storage" error=e
                neo4j_kg = nothing
            end
        else
            @info "Using in-memory knowledge graph backend"
        end
        
        new(
            Dict{String, Dict{String, Any}}(),
            Vector{Dict{String, Any}}(),
            Dict{String, Any}(),
            neo4j_kg
        )
    end
end

"""
    update_knowledge(kg::KnowledgeGraph, experiment::Experiment, result::ExperimentResult)

Updates the knowledge graph with new experiment results.
Uses Neo4j backend if available, otherwise falls back to in-memory storage.
"""
function update_knowledge(kg::KnowledgeGraph, experiment::Experiment, result::ExperimentResult)
    # Try Neo4j backend first
    if kg.neo4j_backend !== nothing
        try
            update_knowledge(kg.neo4j_backend, experiment, result)
            @debug "Updated Neo4j knowledge graph"
        catch e
            @warn "Failed to update Neo4j knowledge graph, updating in-memory instead" error=e
        end
    end
    
    # Always update in-memory storage as backup
    experiment_id = experiment.id
    iteration = length(experiment.history) + 1
    
    # Store experiment node
    if !haskey(kg.experiments, experiment_id)
        kg.experiments[experiment_id] = Dict(
            "research_question" => experiment.research_question,
            "created_at" => experiment.created_at,
            "iterations" => Dict{Int, Any}()
        )
    end
    
    # Store iteration results
    kg.experiments[experiment_id]["iterations"][iteration] = Dict(
        "success" => result.success,
        "metrics" => result.metrics,
        "code" => result.code_generated,
        "execution_time" => 0.0,  # Would come from execution result
        "artifacts" => result.artifacts,
        "summary" => result.evaluation_summary,
        "timestamp" => Dates.now()
    )
    
    @debug "Updated in-memory knowledge graph" experiment_id=experiment_id iteration=iteration
    
    # Extract patterns for future use
    if result.success
        extract_successful_patterns!(kg, result)
    end
    
    # Update cross-experiment connections
    update_connections!(kg, experiment_id, result)
end

"""
    extract_successful_patterns!(kg::KnowledgeGraph, result::ExperimentResult)

Extracts reusable patterns from successful experiments.
"""
function extract_successful_patterns!(kg::KnowledgeGraph, result::ExperimentResult)
    pattern_id = "pattern_$(hash(result.code_generated))"
    
    if !haskey(kg.nodes, pattern_id)
        kg.nodes[pattern_id] = Dict(
            "type" => "pattern",
            "code_snippet" => extract_imports_and_key_lines(result.code_generated),
            "success_count" => 1,
            "metrics" => result.metrics,
            "created_at" => Dates.now()
        )
    else
        # Increment success count
        kg.nodes[pattern_id]["success_count"] += 1
        
        # Update average metrics
        for (metric, value) in result.metrics
            if haskey(kg.nodes[pattern_id]["metrics"], metric)
                current_avg = kg.nodes[pattern_id]["metrics"][metric]
                count = kg.nodes[pattern_id]["success_count"]
                new_avg = (current_avg * (count - 1) + value) / count
                kg.nodes[pattern_id]["metrics"][metric] = new_avg
            else
                kg.nodes[pattern_id]["metrics"][metric] = value
            end
        end
    end
end

"""
    update_connections!(kg::KnowledgeGraph, experiment_id::String, result::ExperimentResult)

Creates connections between related experiments and patterns.
"""
function update_connections!(kg::KnowledgeGraph, experiment_id::String, result::ExperimentResult)
    # Find similar experiments based on metrics
    for (other_exp_id, exp_data) in kg.experiments
        if other_exp_id != experiment_id
            similarity = calculate_metric_similarity(result.metrics, exp_data)
            
            if similarity > 0.7  # Threshold for "similar"
                edge = Dict(
                    "from" => experiment_id,
                    "to" => other_exp_id,
                    "type" => "similar_metrics",
                    "similarity" => similarity,
                    "created_at" => Dates.now()
                )
                push!(kg.edges, edge)
            end
        end
    end
end

"""
    calculate_metric_similarity(metrics1::Dict, exp_data::Dict)

Calculates similarity between metric sets.
"""
function calculate_metric_similarity(metrics1::Dict, exp_data::Dict)
    if !haskey(exp_data, "iterations") || isempty(exp_data["iterations"])
        return 0.0
    end
    
    # Get metrics from most recent successful iteration
    recent_metrics = nothing
    for (iter, iter_data) in exp_data["iterations"]
        if iter_data["success"] && !isempty(iter_data["metrics"])
            recent_metrics = iter_data["metrics"]
        end
    end
    
    if recent_metrics === nothing
        return 0.0
    end
    
    # Simple similarity based on common metrics
    common_metrics = intersect(keys(metrics1), keys(recent_metrics))
    if isempty(common_metrics)
        return 0.0
    end
    
    similarity_sum = 0.0
    for metric in common_metrics
        # Normalize and compare (simple approach)
        diff = abs(metrics1[metric] - recent_metrics[metric])
        max_val = max(abs(metrics1[metric]), abs(recent_metrics[metric]), 1.0)
        similarity_sum += 1.0 - (diff / max_val)
    end
    
    return similarity_sum / length(common_metrics)
end

"""
    extract_imports_and_key_lines(code::String)

Extracts the most important parts of code for pattern matching.
"""
function extract_imports_and_key_lines(code::String)
    lines = split(code, "\n")
    important_lines = String[]
    
    for line in lines
        stripped = strip(line)
        
        # Include imports/using statements
        if startswith(stripped, "using") || startswith(stripped, "import")
            push!(important_lines, stripped)
        end
        
        # Include function definitions
        if startswith(stripped, "function") || contains(stripped, " = ")
            push!(important_lines, stripped)
        end
        
        # Include key calculations (heuristic)
        if contains(stripped, "cor(") || contains(stripped, "mean(") || 
           contains(stripped, "std(") || contains(stripped, "fit(")
            push!(important_lines, stripped)
        end
    end
    
    return join(important_lines, "\n")
end

"""
    query_similar_experiments(kg::KnowledgeGraph, current_experiment::Experiment)

Finds experiments with similar characteristics for learning.
"""
function query_similar_experiments(kg::KnowledgeGraph, current_experiment::Experiment)
    similar_experiments = Vector{Dict{String, Any}}()
    
    # Simple text similarity on research questions
    current_question = lowercase(current_experiment.research_question)
    
    for (exp_id, exp_data) in kg.experiments
        if exp_id != current_experiment.id
            other_question = lowercase(exp_data["research_question"])
            
            # Simple keyword overlap
            current_words = Set(split(current_question))
            other_words = Set(split(other_question))
            overlap = length(intersect(current_words, other_words))
            
            if overlap >= 2  # At least 2 common words
                push!(similar_experiments, Dict(
                    "experiment_id" => exp_id,
                    "research_question" => exp_data["research_question"],
                    "word_overlap" => overlap,
                    "iterations" => length(exp_data["iterations"])
                ))
            end
        end
    end
    
    # Sort by relevance
    sort!(similar_experiments, by=x -> x["word_overlap"], rev=true)
    
    return similar_experiments[1:min(3, length(similar_experiments))]  # Top 3
end

"""
    query_insights(kg::KnowledgeGraph, research_question::String)

Queries the knowledge graph for insights related to a research question.
Uses Neo4j backend if available for advanced graph queries.
"""
function query_insights(kg::KnowledgeGraph, research_question::String)
    insights = Dict{String, Any}()
    
    # Try Neo4j backend for advanced insights
    if kg.neo4j_backend !== nothing
        try
            insights["similar_experiments"] = query_similar_experiments(kg.neo4j_backend, research_question)
            insights["statistics"] = get_experiment_statistics(kg.neo4j_backend)
            insights["successful_patterns"] = query_successful_patterns(kg.neo4j_backend)
            @debug "Retrieved insights from Neo4j"
            return insights
        catch e
            @warn "Failed to query Neo4j insights, falling back to in-memory" error=e
        end
    end
    
    # Fall back to in-memory analysis
    insights["similar_experiments"] = query_similar_experiments_memory(kg, research_question)
    insights["statistics"] = get_experiment_statistics_memory(kg)
    insights["successful_patterns"] = query_successful_patterns_memory(kg)
    @debug "Retrieved insights from in-memory storage"
    
    return insights
end

"""
In-memory implementation of similar experiments query
"""
function query_similar_experiments_memory(kg::KnowledgeGraph, research_question::String)
    similar = []
    query_words = Set(split(lowercase(research_question), r"\\s+"))
    
    for (exp_id, exp_data) in kg.experiments
        exp_words = Set(split(lowercase(exp_data["research_question"]), r"\\s+"))
        overlap = length(intersect(query_words, exp_words))
        
        if overlap > 0
            successful_iterations = count(iter -> iter["success"], values(exp_data["iterations"]))
            if successful_iterations > 0
                push!(similar, Dict(
                    "experiment_id" => exp_id,
                    "question" => exp_data["research_question"],
                    "successful_iterations" => successful_iterations,
                    "similarity_score" => overlap / length(union(query_words, exp_words))
                ))
            end
        end
    end
    
    return sort(similar, by=x -> x["similarity_score"], rev=true)[1:min(5, end)]
end

"""
In-memory implementation of experiment statistics
"""
function get_experiment_statistics_memory(kg::KnowledgeGraph)
    total_experiments = length(kg.experiments)
    total_iterations = 0
    successful_iterations = 0
    
    for (_, exp_data) in kg.experiments
        for (_, iter_data) in exp_data["iterations"]
            total_iterations += 1
            if iter_data["success"]
                successful_iterations += 1
            end
        end
    end
    
    success_rate = total_iterations > 0 ? successful_iterations / total_iterations : 0.0
    
    return Dict(
        "total_experiments" => total_experiments,
        "total_iterations" => total_iterations,
        "successful_iterations" => successful_iterations,
        "success_rate" => success_rate
    )
end

"""
In-memory implementation of successful patterns query
"""
function query_successful_patterns_memory(kg::KnowledgeGraph)
    patterns = Dict{String, Vector{Float64}}()
    
    for (_, exp_data) in kg.experiments
        for (_, iter_data) in exp_data["iterations"]
            if iter_data["success"] && haskey(iter_data, "metrics")
                for (metric, value) in iter_data["metrics"]
                    if isa(value, Number)
                        if !haskey(patterns, metric)
                            patterns[metric] = Float64[]
                        end
                        push!(patterns[metric], Float64(value))
                    end
                end
            end
        end
    end
    
    results = []
    for (metric, values) in patterns
        if length(values) > 1
            push!(results, Dict(
                "metric" => metric,
                "avg_value" => Statistics.mean(values),
                "frequency" => length(values)
            ))
        end
    end
    
    return sort(results, by=x -> x["frequency"], rev=true)[1:min(10, end)]
end

# Enhanced query functions that delegate to Neo4j backend when available

"""
Query techniques that work well for a specific domain
"""
function query_techniques_for_domain(kg::KnowledgeGraph, domain_name::String, limit::Int=10)
    if kg.neo4j_backend !== nothing
        return query_techniques_for_domain(kg.neo4j_backend, domain_name, limit)
    else
        # Fallback to in-memory implementation
        return []  # Not implemented for in-memory yet
    end
end

"""
Query reusable code patterns with success metrics
"""
function query_code_patterns(kg::KnowledgeGraph, category::String="", limit::Int=10)
    if kg.neo4j_backend !== nothing
        return query_code_patterns(kg.neo4j_backend, category, limit)
    else
        # Fallback to in-memory implementation
        return []  # Not implemented for in-memory yet
    end
end

"""
Query experiment lineage and relationships
"""
function query_experiment_lineage(kg::KnowledgeGraph, experiment_id::String)
    if kg.neo4j_backend !== nothing
        return query_experiment_lineage(kg.neo4j_backend, experiment_id)
    else
        # Fallback to in-memory implementation
        return Dict()  # Not implemented for in-memory yet
    end
end

"""
Query patterns that work across different domains (transfer learning opportunities)
"""
function query_cross_domain_patterns(kg::KnowledgeGraph, limit::Int=10)
    if kg.neo4j_backend !== nothing
        return query_cross_domain_patterns(kg.neo4j_backend, limit)
    else
        # Fallback to in-memory implementation
        return []  # Not implemented for in-memory yet
    end
end

"""
Query similarity relationships between experiments
"""
function query_similarity_relationships(kg::KnowledgeGraph, limit::Int=10)
    if kg.neo4j_backend !== nothing
        return query_similarity_relationships(kg.neo4j_backend, limit)
    else
        # Fallback to in-memory implementation
        return []  # Not implemented for in-memory yet
    end
end

"""
Query domain statistics and experiment counts
"""
function query_domain_statistics(kg::KnowledgeGraph)
    if kg.neo4j_backend !== nothing
        return query_domain_statistics(kg.neo4j_backend)
    else
        # Fallback to in-memory implementation
        return []  # Not implemented for in-memory yet
    end
end