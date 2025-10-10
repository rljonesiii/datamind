#!/usr/bin/env julia

"""
Enhanced DSAssist Workflow with Vector Database Integration

Demonstrates the full agentic workflow using semantic search capabilities
for improved agent coordination and knowledge discovery.
"""

using Pkg
Pkg.activate(".")

include("../src/DSAssist.jl")
using .DSAssist
using Printf

function main()
    println("🚀 ENHANCED DSASSIST WORKFLOW WITH VECTOR DATABASE")
    println("="^60)
    
    # Configuration with vector database support
    config = Dict(
        "agents" => Dict(
            "planning" => Dict(
                "model" => "gpt-4",
                "temperature" => 0.3
            ),
            "codegen" => Dict(
                "model" => "gpt-4", 
                "temperature" => 0.1
            ),
            "evaluation" => Dict(
                "model" => "gpt-4",
                "temperature" => 0.2
            )
        ),
        "execution" => Dict(
            "timeout" => 30,
            "memory_limit" => "1GB"
        ),
        "vector_db" => Dict(
            "enabled" => true,
            "embedding_model" => "openai",  # or "simple" for fallback
            "similarity_threshold" => 0.5
        )
    )
    
    # Create a simple experiment for testing
    println("📊 Creating Enhanced Experiment...")
    research_question = "What are the key patterns in weather data that affect energy consumption?"
    experiment = Experiment(research_question)
    
    # Add some mock context for demonstration
    experiment.context["data_shape"] = "(1000, 8)"
    experiment.context["data_file"] = "data/weather_data.csv"
    
    println("🧠 Initializing Enhanced Meta-Controller...")
    controller = MetaController(experiment, config)
    
    # Verify enhanced knowledge graph is working
    if controller.knowledge_graph isa EnhancedKnowledgeGraph
        println("✅ Enhanced Knowledge Graph with Vector Database active")
        println("   • Semantic similarity search enabled")
        println("   • Cross-domain pattern recognition active")
        println("   • Intelligent agent coordination ready")
    else
        println("⚠️  Basic Knowledge Graph active (vector database unavailable)")
    end
    
    println("\n🔄 Starting Enhanced Agentic Workflow...")
    println("="^60)
    
    # Run the enhanced experiment cycle
    results = run_experiment_cycle(controller, 3)
    
    println("\n📋 ENHANCED WORKFLOW RESULTS")
    println("="^60)
    
    for (i, result) in enumerate(results)
        status = result.success ? "✅ SUCCESS" : "❌ FAILURE"
        println("Iteration $i: $status")
        println("  Summary: $(result.evaluation_summary)")
        if !isempty(result.metrics)
            println("  Metrics: $(result.metrics)")
        end
        println()
    end
    
    # Demonstrate semantic search capabilities
    if controller.knowledge_graph isa EnhancedKnowledgeGraph
        println("🔍 SEMANTIC SEARCH DEMONSTRATION")
        println("="^40)
        
        test_queries = [
            "temperature correlation analysis",
            "energy consumption patterns", 
            "weather impact on demand",
            "statistical modeling approaches"
        ]
        
        for query in test_queries
            println("\n🔎 Query: \"$query\"")
            try
                insights = enhanced_query_insights(controller.knowledge_graph, query, k=3)
                if !isempty(insights)
                    for insight in insights
                        similarity = get(insight, "semantic_similarity", get(insight, "combined_score", 0.0))
                        println("  • $(insight["research_question"]) ($(round(similarity*100, digits=1))% match)")
                    end
                else
                    println("  • No similar experiments found")
                end
            catch e
                println("  • Search error: $e")
            end
        end
    end
    
    println("\n🎉 ENHANCED WORKFLOW COMPLETE!")
    println("="^60)
    println("The vector database integration enables:")
    println("• 🧠 Semantic understanding of research questions")
    println("• 🔍 Cross-domain knowledge discovery") 
    println("• ⚡ Intelligent agent coordination")
    println("• 📈 Continuous learning from experiment patterns")
    println("• 🎯 Context-aware planning and code generation")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end