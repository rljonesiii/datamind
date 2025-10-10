#!/usr/bin/env julia

# Test Knowledge Graph Fallback Behavior

using Pkg
Pkg.activate(".")

# Get the script directory and navigate to project root
script_dir = dirname(@__FILE__)
project_root = dirname(script_dir)
cd(project_root)

# Temporarily disable Neo4j by unsetting the password
original_password = get(ENV, "NEO4J_PASSWORD", "")
ENV["NEO4J_PASSWORD"] = ""  # Force fallback to in-memory

include(joinpath(project_root, "src", "DataMind.jl"))
using .DataMind

function test_fallback_behavior()
    println("🧪 Testing Knowledge Graph Fallback Behavior")
    println("=" ^ 50)
    
    try
        # Test 1: Create knowledge graph (should fallback to in-memory)
        println("📝 Test 1: Creating knowledge graph (should use in-memory)...")
        kg = KnowledgeGraph()
        
        if kg.neo4j_backend === nothing
            println("✅ Successfully fell back to in-memory backend")
        else
            println("❌ Expected fallback but Neo4j backend was created")
            return false
        end
        
        # Test 2: Test in-memory functionality
        println("\n📝 Test 2: Testing in-memory knowledge graph...")
        experiment = Experiment("Test in-memory fallback functionality")
        result = ExperimentResult(
            true,  # success
            Dict("accuracy" => 0.95, "precision" => 0.92),  # metrics
            ["test_plot.png"],  # artifacts
            "test_code = 'in-memory test'",  # code_generated
            "Test executed successfully",  # execution_output
            "In-memory test completed",  # evaluation_summary
            ["validate_fallback"]  # next_actions
        )
        
        update_knowledge(kg, experiment, result)
        println("✅ Successfully updated in-memory knowledge graph")
        
        # Test 3: Query insights from in-memory
        println("\n📝 Test 3: Querying insights from in-memory backend...")
        insights = query_insights(kg, "test patterns")
        
        println("📊 In-Memory Insights:")
        if haskey(insights, "statistics")
            stats = insights["statistics"]
            println("   • Total experiments: $(stats["total_experiments"])")
            println("   • Total iterations: $(stats["total_iterations"])")
            println("   • Success rate: $(round(stats["success_rate"] * 100, digits=1))%")
        end
        
        if haskey(insights, "recent_experiments") && !isempty(insights["recent_experiments"])
            println("   • Recent experiments:")
            for exp in insights["recent_experiments"][1:min(3, end)]
                println("     - $(exp["question"])")
            end
        end
        
        println("\n🎉 Fallback behavior test PASSED!")
        return true
        
    catch e
        println("❌ Test failed with error: $e")
        println("📍 Error type: $(typeof(e))")
        return false
    finally
        # Restore original Neo4j password
        if !isempty(original_password)
            ENV["NEO4J_PASSWORD"] = original_password
            println("\n🔄 Restored Neo4j credentials")
        end
    end
end

# Run the test
if test_fallback_behavior()
    println("\n✅ Fallback test completed successfully!")
    exit(0)
else
    println("\n❌ Fallback test failed!")
    exit(1)
end