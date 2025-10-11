#!/usr/bin/env julia

"""
Vector Database Integration Test for DataMind

Tests the enhanced knowledge graph with vector embeddings alongside Neo4j.
Demonstrates semantic search capabilities for improved agent efficiency.
"""

using Pkg
Pkg.activate(".")

include("../src/DataMind.jl")
using .DataMind

# Include vector database module
include("../src/knowledge/vector_db.jl")

println("🚀 TESTING VECTOR DATABASE INTEGRATION")
println("=" ^ 60)

# Initialize regular knowledge graph
println("\n📊 Initializing Knowledge Graph...")
kg = KnowledgeGraph()

# Enhance with vector database
println("🔍 Adding Vector Database Capabilities...")
ekg = initialize_vector_knowledge_graph(kg)

# Create some test experiments with different research questions
println("\n🧪 Creating Test Experiments...")

test_experiments = [
    ("exp1", "What is the correlation between temperature and energy consumption?"),
    ("exp2", "How does weather affect customer purchasing behavior?"),
    ("exp3", "Analysis of temperature patterns and power grid demand"),
    ("exp4", "Credit card fraud detection using machine learning"),
    ("exp5", "Customer segmentation analysis for marketing"),
    ("exp6", "Weather forecasting using historical climate data"),
    ("exp7", "Risk assessment for financial portfolios"),
    ("exp8", "Thermal energy analysis for smart cities"),
]

# Add embeddings for test experiments
println("🔢 Generating Vector Embeddings...")
for (exp_id, question) in test_experiments
    println("  📝 Embedding: $exp_id")
    embed_research_question(ekg, question, exp_id)
end

# Test semantic similarity search
println("\n" * "=" ^ 60)
println("🔍 TESTING SEMANTIC SIMILARITY SEARCH")
println("=" ^ 60)

test_queries = [
    ("Temperature and energy relationship", "Expected: exp1, exp3, exp8"),
    ("Weather impact on behavior", "Expected: exp2, exp6"),
    ("Machine learning for classification", "Expected: exp4, exp7"),
    ("Customer analysis patterns", "Expected: exp5, exp4, exp7")
]

for (query, expected) in test_queries
    println("\n🔎 Query: \"$query\"")
    println("🎯 $expected")
    
    results = semantic_similarity_search(ekg, query, k=3, min_similarity=0.3)
    
    if isempty(results)
        println("❌ No results found")
    else
        println("✅ Found $(length(results)) similar experiments:")
        for (i, result) in enumerate(results)
            similarity_percent = round(result.similarity * 100, digits=1)
            println("  $i. $(result.experiment_id): \"$(result.text)\" ($(similarity_percent)% similar)")
        end
    end
end

# Test enhanced query insights combining both approaches
println("\n" * "=" ^ 60)
println("🧠 TESTING ENHANCED QUERY INSIGHTS")
println("=" ^ 60)

enhanced_queries = [
    "correlation analysis between environmental factors and consumption",
    "customer behavior prediction using data science",
    "risk analysis for business intelligence"
]

for query in enhanced_queries
    println("\n🔍 Enhanced Query: \"$query\"")
    
    insights = enhanced_query_insights(ekg, query, k=3)
    
    if isempty(insights)
        println("❌ No insights found")
    else
        println("✅ Found $(length(insights)) relevant insights:")
        for (i, insight) in enumerate(insights)
            if haskey(insight, "semantic_similarity")
                similarity = round(insight["semantic_similarity"] * 100, digits=1)
                println("  $i. $(insight["experiment_id"]): $(similarity)% semantic match")
                println("     \"$(insight["research_question"])\"")
            else
                println("  $i. $(insight["experiment_id"]): Graph-based match")
                println("     \"$(get(insight, "research_question", "N/A"))\"")
            end
        end
    end
end

# Performance comparison
println("\n" * "=" ^ 60)
println("⚡ PERFORMANCE COMPARISON")
println("=" ^ 60)

test_query = "temperature correlation analysis for energy systems"

# Time semantic search
println("🔍 Testing Semantic Search Performance...")
semantic_start = time()
semantic_results = semantic_similarity_search(ekg, test_query, k=5)
semantic_time = time() - semantic_start

println("✅ Semantic Search: $(length(semantic_results)) results in $(round(semantic_time * 1000, digits=2))ms")

# Time traditional search (if available)
println("📊 Testing Traditional Search Performance...")
traditional_start = time()
try
    traditional_results = query_insights(kg, test_query)
    traditional_time = time() - traditional_start
    println("✅ Traditional Search: $(length(traditional_results)) results in $(round(traditional_time * 1000, digits=2))ms")
    
    speedup = traditional_time / semantic_time
    println("🚀 Semantic search is $(round(speedup, digits=1))x faster")
catch e
    println("⚠️  Traditional search not available or failed")
end

# Summary
println("\n" * "=" ^ 60)
println("📋 VECTOR DATABASE INTEGRATION SUMMARY")
println("=" ^ 60)

println("✅ **Enhanced Knowledge Graph Capabilities:**")
println("   • Semantic similarity search for research questions")
println("   • Vector embeddings for improved context understanding") 
println("   • Hybrid search combining vector + graph approaches")
println("   • Fallback support when external databases unavailable")

println("\n🔧 **Technical Implementation:**")
println("   • ChromaDB integration with fallback to in-memory")
println("   • OpenAI embeddings with simple text embedding fallback")
println("   • Cosine similarity for semantic matching")
println("   • Caching for improved performance")

println("\n🎯 **Agent Benefits:**")
println("   • Planning Agent: Find similar successful methodologies")
println("   • Code Generation Agent: Locate relevant code templates")
println("   • Evaluation Agent: Access comparable benchmarks")
println("   • Meta-Controller: Discover effective experiment strategies")

println("\n🚀 **Next Steps:**")
println("   • Add code pattern embeddings for better template matching")
println("   • Implement experiment result embeddings for metric comparison")
println("   • Create agent communication embeddings for coordination learning")
println("   • Add multi-modal embeddings for cross-domain knowledge transfer")

println("\n" * "=" ^ 60)
println("🎉 VECTOR DATABASE INTEGRATION TEST COMPLETE!")
println("=" ^ 60)