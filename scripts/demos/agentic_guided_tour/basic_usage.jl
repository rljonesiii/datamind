#!/usr/bin/env julia

# Basic Usage Examples
# Simple demonstrations of agentic data science workflows

using Pkg
Pkg.activate(".")

# Environment variables are automatically loaded by DataMind module

# Load enhanced workflow foundation
include("../../../src/workflows/enhanced_workflow_foundation.jl")
using .EnhancedWorkflow

# Example 1: Simple correlation analysis
function example_correlation_analysis()
    println("🔍 Example: Correlation Analysis")
    
    research_question = "Do height and weight correlate in adults?"
    data_context = Dict(
        "description" => "Synthetic adult height and weight measurements for correlation analysis",
        "data_type" => "synthetic",
        "analysis_type" => "correlation"
    )
    
    experiment = create_enhanced_experiment(research_question, data_context)
    controller = create_enhanced_controller(experiment)
    results = run_enhanced_workflow(controller, 5, show_semantic_demo=false)
    
    println("✅ Correlation analysis completed!")
    return results
end

# Example 2: Predictive modeling
function example_predictive_modeling() 
    println("🔍 Example: Predictive modeling")
    
    research_question = "Can we predict house prices from basic features?"
    data_context = Dict(
        "description" => "Housing dataset with features like bedrooms, bathrooms, square footage",
        "data_type" => "real_estate",
        "analysis_type" => "prediction"
    )
    
    experiment = create_enhanced_experiment(research_question, data_context)
    controller = create_enhanced_controller(experiment)
    results = run_enhanced_workflow(controller, 8, show_semantic_demo=false)
    
    println("✅ Predictive modeling completed!")
    return results
end

# Example 3: Data quality assessment
function example_data_quality()
    println("🔍 Example: Data Quality Assessment")
    
    research_question = "What data quality issues exist in this dataset?"
    data_context = Dict(
        "description" => "Customer dataset requiring comprehensive quality assessment",
        "data_type" => "customer_data",
        "analysis_type" => "data_quality"
    )
    
    experiment = create_enhanced_experiment(research_question, data_context)
    controller = create_enhanced_controller(experiment)
    results = run_enhanced_workflow(controller, 3, show_semantic_demo=false)
    
    println("✅ Data quality assessment completed!")
    return results
end

# Run examples
if abspath(PROGRAM_FILE) == @__FILE__
    example_correlation_analysis()
    println("\n" * "="^50 * "\n")
    example_predictive_modeling()
    println("\n" * "="^50 * "\n") 
    example_data_quality()
end