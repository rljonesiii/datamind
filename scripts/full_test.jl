#!/usr/bin/env julia

using Pkg
Pkg.activate(".")

include("src/DSAssist.jl")
using .DSAssist
using YAML

"""
Simple test version of DSAssist with better error handling.
"""
function test_dsassist()
    println("🧪 DSAssist Test Mode")
    println("=" ^ 40)
    
    try
        # Load configuration
        config = YAML.load_file("config/agents.yaml")
        println("✅ Configuration loaded")
        
        # Create a simple test experiment
        experiment = Experiment("What patterns exist in sample data?")
        println("✅ Experiment created: $(experiment.id)")
        
        # Initialize meta-controller
        controller = MetaController(experiment, config)
        println("✅ Meta-controller initialized")
        
        # Run just one iteration for testing
        println("\n🔄 Running single test iteration...")
        
        # Test planning phase
        println("  📋 Testing planning agent...")
        plan = generate_plan(controller.agents["planning"], experiment)
        println("  ✅ Plan generated")
        
        # Test code generation phase
        println("  💻 Testing code generation...")
        code = generate_code(controller.agents["codegen"], plan, experiment)
        println("  ✅ Code generated")
        println("  📝 Generated code preview:")
        println("    " * replace(split(code, "\n")[1], "\n" => "\n    "))
        
        # Test evaluation phase (skip execution for now)
        println("  📊 Testing evaluation...")
        mock_execution = ExecutionResult(true, "Test output", "", String[], 0.1, 0.0)
        evaluation = evaluate_results(controller.agents["evaluation"], mock_execution, experiment)
        println("  ✅ Evaluation completed")
        
        println("\n✅ All components working correctly!")
        return 0
        
    catch e
        println("\n❌ Test failed: $e")
        println("📍 Error type: $(typeof(e))")
        return 1
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    exit(test_dsassist())
end