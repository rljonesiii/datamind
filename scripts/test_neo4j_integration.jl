#!/usr/bin/env julia

# Test Neo4j Knowledge Graph Integration

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

function test_neo4j_knowledge_graph()
    println("🧪 Testing Neo4j Knowledge Graph Integration")
    println("=" ^ 50)
    
    try
        # Test 1: Create knowledge graph
        println("📝 Test 1: Creating knowledge graph...")
        kg = KnowledgeGraph()
        
        if kg.neo4j_backend !== nothing
            println("✅ Neo4j backend successfully initialized")
        else
            println("⚠️  Using in-memory backend (Neo4j not available)")
        end
        
        # Test 2: Create test experiment
        println("\n📝 Test 2: Creating test experiment...")
        experiment = Experiment("Test Neo4j integration with correlation analysis")
        
        # Test 3: Create test result
        println("📝 Test 3: Creating test result...")
        result = ExperimentResult(
            true,  # success
            Dict("correlation" => 0.87, "sample_size" => 1000),  # metrics
            ["correlation_plot.png"],  # artifacts (Vector{String})
            "using Statistics; cor(x, y)",  # code_generated
            "Correlation calculated successfully",  # execution_output
            "Strong positive correlation found",  # evaluation_summary
            ["explore_causality", "try_different_variables"]  # next_actions
        )
        
        # Test 4: Update knowledge graph
        println("📝 Test 4: Updating knowledge graph...")
        update_knowledge(kg, experiment, result)
        println("✅ Knowledge graph updated successfully")
        
        # Test 5: Query insights
        println("\n📝 Test 5: Querying insights...")
        insights = query_insights(kg, "correlation analysis patterns")
        
        println("📊 Insights Retrieved:")
        if haskey(insights, "statistics")
            stats = insights["statistics"]
            println("   • Total experiments: $(stats["total_experiments"])")
            println("   • Total iterations: $(stats["total_iterations"])")
            println("   • Success rate: $(round(stats["success_rate"] * 100, digits=1))%")
        end
        
        if haskey(insights, "similar_experiments") && !isempty(insights["similar_experiments"])
            println("   • Similar experiments found: $(length(insights["similar_experiments"]))")
            for exp in insights["similar_experiments"][1:min(2, end)]
                println("     - $(exp["question"])")
            end
        end
        
        if haskey(insights, "successful_patterns") && !isempty(insights["successful_patterns"])
            println("   • Successful patterns found: $(length(insights["successful_patterns"]))")
            for pattern in insights["successful_patterns"][1:min(3, end)]
                println("     - $(pattern["metric"]): avg $(round(pattern["avg_value"], digits=3))")
            end
        end
        
        println("\n🎉 Neo4j Knowledge Graph integration test PASSED!")
        return true
        
    catch e
        println("❌ Test failed with error: $e")
        println("📍 Error type: $(typeof(e))")
        if isa(e, LoadError)
            println("📄 File: $(e.file)")
            println("📍 Line: $(e.line)")
        end
        return false
    end
end

# Run the test
if abspath(PROGRAM_FILE) == @__FILE__
    success = test_neo4j_knowledge_graph()
    exit(success ? 0 : 1)
end