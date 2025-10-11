#!/usr/bin/env julia

# Test improved data loading with better prompts
using Pkg
Pkg.activate(".")

include("scripts/development/enhanced_workflow_foundation.jl")
using .EnhancedWorkflow

println("🔍 TESTING IMPROVED DATA LOADING...")

# Create an experiment with explicit data_path instructions
research_question = "Load credit card data using data_path function and show summary statistics"
data_context = Dict(
    "data_file" => "data/cc_data.csv", 
    "data_shape" => "(8950, 18)",
    "columns" => ["CUST_ID", "BALANCE", "BALANCE_FREQUENCY", "PURCHASES"],
    "instructions" => "Use data_path(\"cc_data.csv\") to load the data file"
)

println("Creating experiment with enhanced context...")
experiment = create_enhanced_experiment(research_question, data_context)
controller = create_enhanced_controller(experiment)

println("Testing improved workflow...")
try
    results = run_enhanced_workflow(controller, 1)  # Run just 1 iteration
    println("✅ Workflow completed successfully!")
    for (i, result) in enumerate(results)
        println("Iteration $i: $(result.success ? "✅ SUCCESS" : "❌ FAILURE")")
        if result.success
            println("  Metrics: $(result.metrics)")
        else
            println("  Error context provided for learning")
        end
    end
catch e
    println("❌ Exception: ", e)
end