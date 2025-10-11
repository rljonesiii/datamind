#!/usr/bin/env julia

"""
Interactive Demo Test - Non-Pluto Version

This script tests the functionality that would be available in the Pluto interactive demo
without requiring the Pluto notebook environment.
"""

using Pkg
Pkg.activate(".")

# Get project root and activate
script_dir = @__DIR__
project_root = joinpath(script_dir, "..", "..", "..")

include(joinpath(project_root, "src", "DataMind.jl"))
using .DataMind
using Printf, YAML

function main()
    println("🎯 DSASSIST INTERACTIVE DEMO TEST")
    println("="^60)
    println("📝 This simulates what the Pluto notebook would do interactively")
    println()
    
    # Simulate different research questions that would be input interactively
    test_questions = [
        "What factors influence customer satisfaction in our credit card data?",
        "Can you identify spending patterns that predict customer churn?", 
        "What are the key risk factors for payment defaults?"
    ]
    
    for (i, question) in enumerate(test_questions)
        println("🔍 TEST SCENARIO $i")
        println("-"^40)
        println("📝 Research Question: \"$question\"")
        println()
        
        try
            # Load configuration
            config = YAML.load_file("config/agents.yaml")
            
            # Create and run experiment (similar to what Pluto notebook would do)
            println("🤖 Creating agentic experiment...")
            experiment = Experiment(question)
            
            println("🧠 Initializing meta-controller...")
            controller = MetaController(experiment, config)
            
            println("⚡ Running autonomous analysis...")
            results = run_experiment_cycle(controller, 2)  # Run 2 iterations for demo
            
            println("✅ Experiment completed successfully!")
            println("📊 Results: $(length(results)) iterations completed")
            
            # Display key insights from results
            if !isempty(results)
                final_result = results[end]
                println("💡 Final Analysis:")
                println("   • Success: $(final_result.success)")
                if !isempty(final_result.metrics)
                    println("   • Key metrics: $(length(final_result.metrics)) metrics calculated")
                end
                println("   • Summary: $(final_result.evaluation_summary)")
            end
            
        catch e
            println("⚠️  Experiment failed: $e")
        end
        
        println()
        println("="^60)
        println()
    end
    
    println("🎉 INTERACTIVE DEMO TEST COMPLETE!")
    println()
    println("💡 In the actual Pluto notebook, users would:")
    println("   • Enter research questions in an interactive text field")
    println("   • Click buttons to start autonomous analysis")
    println("   • See real-time results and visualizations")
    println("   • Modify questions and re-run experiments instantly")
    println()
    println("🚀 To run the actual interactive version:")
    println("   1. Start Pluto: julia -e 'using Pluto; Pluto.run()'")
    println("   2. Open: scripts/demos/agentic_guided_tour/interactive_demo.jl")
    println("   3. Interact with the web interface")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end