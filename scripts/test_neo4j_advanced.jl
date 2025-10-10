#!/usr/bin/env julia

# Advanced Neo4j Knowledge Graph Integration Test

using Pkg
Pkg.activate(".")

# Get the script directory and navigate to project root
script_dir = dirname(@__FILE__)
project_root = dirname(script_dir)
cd(project_root)

# Load environment variables from .env file
function load_env_file(filepath=".env")
    if isfile(filepath)
        for line in readlines(filepath)
            line = strip(line)
            if !isempty(line) && !startswith(line, "#") && contains(line, "=")
                key, value = split(line, "=", limit=2)
                ENV[strip(key)] = strip(value)
            end
        end
        println("📋 Loaded environment variables from $filepath")
    else
        println("⚠️  .env file not found at $filepath")
    end
end

load_env_file()

include(joinpath(project_root, "src", "DataMind.jl"))
using .DataMind

function test_neo4j_advanced()
    println("🧪 Advanced Neo4j Knowledge Graph Testing")
    println("=" ^ 50)
    
    try
        # Test 1: Create knowledge graph
        println("📝 Test 1: Creating knowledge graph...")
        kg = KnowledgeGraph()
        
        if kg.neo4j_backend !== nothing
            println("✅ Neo4j backend successfully initialized")
        else
            println("⚠️  Using in-memory backend (Neo4j not available)")
            return false
        end
        
        # Test 2: Create multiple experiments
        println("\n📝 Test 2: Creating multiple experiments...")
        experiments = [
            ("Analyze correlation between temperature and sales", Dict("correlation" => 0.78, "p_value" => 0.001)),
            ("Linear regression for price prediction", Dict("r_squared" => 0.85, "mse" => 0.12)),
            ("Time series analysis of stock prices", Dict("correlation" => 0.62, "volatility" => 0.08)),
            ("Classification accuracy with random forest", Dict("accuracy" => 0.92, "f1_score" => 0.89))
        ]
        
        for (i, (question, metrics)) in enumerate(experiments)
            experiment = Experiment(question)
            result = ExperimentResult(
                true,  # success
                metrics,  # metrics
                ["plot_$i.png", "model_$i.pkl"],  # artifacts
                "# Analysis code for experiment $i\nimport pandas as pd\n# Implementation...",  # code_generated
                "Execution completed successfully",  # execution_output
                "Analysis shows $(question)",  # evaluation_summary
                ["refine_model", "add_features"]  # next_actions
            )
            
            update_knowledge(kg, experiment, result)
            println("   ✅ Added experiment $i: $(question[1:min(50, end)])...")
        end
        
        # Test 3: Query for similar experiments
        println("\n📝 Test 3: Testing similarity queries...")
        
        # Test correlation-related queries
        insights = query_insights(kg, "correlation analysis patterns")
        println("\n📊 Correlation Analysis Insights:")
        if haskey(insights, "similar_experiments") && !isempty(insights["similar_experiments"])
            println("   • Found $(length(insights["similar_experiments"])) similar experiments:")
            for exp in insights["similar_experiments"][1:min(3, end)]
                println("     - $(exp["question"])")
            end
        end
        
        if haskey(insights, "successful_patterns") && !isempty(insights["successful_patterns"])
            println("   • Successful patterns:")
            for pattern in insights["successful_patterns"][1:min(3, end)]
                println("     - $(pattern["metric"]): avg $(round(pattern["avg_value"], digits=3))")
            end
        end
        
        # Test machine learning queries
        println("\n📝 Test 4: Testing ML-specific queries...")
        ml_insights = query_insights(kg, "machine learning model performance")
        println("\n📊 Machine Learning Insights:")
        if haskey(ml_insights, "similar_experiments") && !isempty(ml_insights["similar_experiments"])
            println("   • Found $(length(ml_insights["similar_experiments"])) ML experiments:")
            for exp in ml_insights["similar_experiments"][1:min(3, end)]
                println("     - $(exp["question"])")
            end
        end
        
        # Test 5: Statistics summary
        println("\n📝 Test 5: Overall statistics...")
        stats_insights = query_insights(kg, "experiment statistics")
        if haskey(stats_insights, "statistics")
            stats = stats_insights["statistics"]
            println("📊 Database Statistics:")
            println("   • Total experiments: $(stats["total_experiments"])")
            println("   • Total iterations: $(stats["total_iterations"])")
            println("   • Success rate: $(round(stats["success_rate"] * 100, digits=1))%")
            
            if haskey(stats, "most_common_metrics") && !isempty(stats["most_common_metrics"])
                println("   • Most common metrics:")
                for metric in stats["most_common_metrics"][1:min(3, end)]
                    println("     - $(metric["metric"]): used $(metric["count"]) times")
                end
            end
        end
        
        println("\n🎉 Advanced Neo4j Knowledge Graph test PASSED!")
        return true
        
    catch e
        println("❌ Test failed with error: $e")
        println("📍 Error type: $(typeof(e))")
        if isa(e, StackOverflowError)
            println("📍 Stack trace (first 10 lines):")
            for (i, frame) in enumerate(stacktrace(catch_backtrace())[1:min(10, end)])
                println("   $i: $frame")
            end
        else
            println("📍 Full error: $e")
        end
        return false
    end
end

# Run the test
if test_neo4j_advanced()
    println("\n✅ All tests completed successfully!")
    exit(0)
else
    println("\n❌ Tests failed!")
    exit(1)
end