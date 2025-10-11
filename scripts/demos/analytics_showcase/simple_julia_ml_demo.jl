#!/usr/bin/env julia

"""
Simple Julia ML Demo

Quick demonstration of the Julia native ML capabilities.
Shows the basic usage examples mentioned in the conversion summary.

Run this for a quick demo:
    julia scripts/simple_julia_ml_demo.jl
"""

using Pkg
Pkg.activate(".")

push!(LOAD_PATH, joinpath(@__DIR__, "..", "..", "src"))

using DataFrames
using DataMind

function demo()
    println("🚀 Quick Julia ML Demo")
    println("="^30)
    
    # Example from the conversion summary
    println("\n📊 Example 1: Load data (faster than pandas)")
    df = DataMind.JuliaNativeML.load_and_prepare_data("data/product_sales.csv")
    println("✅ Loaded $(nrow(df)) products")
    
    println("\n🤖 Example 2: Run ML analysis (native Julia)")  
    results = DataMind.JuliaNativeML.compare_ensemble_methods(
        "data/product_sales.csv", 
        "price", 
        ["rating", "reviews_count", "category"]
    )
    println("✅ ML analysis complete - $(length(results)) methods compared")
    
    println("\n🎯 Best performing method:")
    best_method = ""
    best_r2 = -Inf
    for (method, metrics) in results
        if haskey(metrics, "r2") && metrics["r2"] > best_r2
            best_r2 = metrics["r2"]
            best_method = method
        end
    end
    println("   $best_method (R² = $(round(best_r2, digits=3)))")
    
    println("\n✨ Performance benefits unlocked! 🚀")
end

# Run the demo
demo()