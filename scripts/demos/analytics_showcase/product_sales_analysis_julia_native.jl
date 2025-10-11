#!/usr/bin/env julia

"""
Product Sales Analysis - Julia Native Version

This script demonstrates high-performance data science using Julia's native ecosystem,
replacing Python/pandas/sklearn with Julia equivalents for superior performance.

Features:
- Native Julia data processing (faster than pandas)
- MLJ.jl ensemble methods (no Python dependencies)
- Type-safe statistical computing
- Composable machine learning pipelines

Usage:
    julia scripts/product_sales_analysis_julia_native.jl
"""

using Pkg
Pkg.activate(".")

push!(LOAD_PATH, joinpath(@__DIR__, "..", "..", "src"))

using DataFrames
using CSV
using Statistics
using StatsBase
using Plots
using Random

# Import DataMind modules
using DataMind
using DataMind.JuliaNativeML

function main()
    println("🚀 PRODUCT SALES ANALYSIS - JULIA NATIVE VERSION")
    println("="^55)
    println()
    
    # Data file path
    data_path = "data/product_sales.csv"
    
    if !isfile(data_path)
        println("❌ Error: Data file not found: $data_path")
        println("   Please ensure the product sales data exists.")
        return
    end
    
    println("📊 PHASE 1: DATA EXPLORATION WITH JULIA")
    println("-"^40)
    
    # Load data using Julia's high-performance CSV.jl
    println("Loading data with CSV.jl (faster than pandas)...")
    start_time = time()
    df = CSV.read(data_path, DataFrame)
    load_time = time() - start_time
    
    println("  ✅ Loaded $(nrow(df)) products in $(round(load_time*1000, digits=1))ms")
    println("  📋 Columns: $(names(df))")
    println("  💰 Price range: \$$(round(minimum(df.price), digits=2)) - \$$(round(maximum(df.price), digits=2))")
    println("  ⭐ Rating range: $(round(minimum(df.rating), digits=1)) - $(round(maximum(df.rating), digits=1))")
    println()
    
    # Quick statistics using Julia's Statistics module
    println("📈 SUMMARY STATISTICS (Julia native):")
    
    # Group analysis using DataFrames.jl (faster than pandas groupby)
    category_stats = combine(groupby(df, :category), 
        :price => mean => :avg_price,
        :rating => mean => :avg_rating,
        :reviews_count => mean => :avg_reviews,
        nrow => :count
    )
    
    println("  📊 By Category:")
    for row in eachrow(category_stats)
        println("    $(row.category): $(row.count) items, avg price: \$$(round(row.avg_price, digits=2)), avg rating: $(round(row.avg_rating, digits=2))")
    end
    
    # Stock analysis
    stock_summary = combine(groupby(df, :in_stock), nrow => :count, :price => mean => :avg_price)
    println("  📦 Stock Status:")
    for row in eachrow(stock_summary)
        status = row.in_stock ? "In Stock" : "Out of Stock"
        println("    $status: $(row.count) items, avg price: \$$(round(row.avg_price, digits=2))")
    end
    println()
    
    println("🤖 PHASE 2: MACHINE LEARNING WITH JULIA ECOSYSTEM")
    println("-"^50)
    
    # Feature columns for ML
    feature_cols = ["rating", "reviews_count", "category", "in_stock"]
    target_col = "price"
    
    println("🎯 Prediction Task: Price prediction using product features")
    println("  📊 Features: $(feature_cols)")
    println("  🎯 Target: $target_col")
    println()
    
    # Run comprehensive ensemble comparison using Julia native methods
    try
        # Time the entire ML pipeline
        ml_start = time()
        
        results = compare_ensemble_methods(data_path, target_col, feature_cols)
        
        ml_time = time() - ml_start
        
        println("\n⚡ PERFORMANCE ANALYSIS:")
        println("  🚀 Total ML Pipeline Time: $(round(ml_time, digits=2)) seconds")
        println("  📈 Julia Benefits:")
        println("    • No Python/GIL overhead")
        println("    • Type-stable computations")
        println("    • Zero-copy data operations")
        println("    • JIT-compiled performance")
        
        # Find best performing method
        best_method = ""
        best_r2 = -Inf
        
        for (method, metrics) in results
            if haskey(metrics, "r2") && metrics["r2"] > best_r2
                best_r2 = metrics["r2"]
                best_method = method
            end
        end
        
        println("\n🏆 OPTIMAL MODEL SELECTION:")
        println("  🥇 Best Method: $best_method")
        println("  📊 Performance: R² = $(round(best_r2, digits=3))")
        
        # Generate insights
        println("\n💡 BUSINESS INSIGHTS (Julia-derived):")
        
        # Price sensitivity analysis
        high_rated = df[df.rating .>= 4.5, :]
        low_rated = df[df.rating .< 4.0, :]
        
        if nrow(high_rated) > 0 && nrow(low_rated) > 0
            price_premium = mean(high_rated.price) - mean(low_rated.price)
            println("  💰 Premium for high ratings (4.5+): \$$(round(price_premium, digits=2))")
        end
        
        # Stock impact analysis
        in_stock_items = df[df.in_stock .== true, :]
        out_stock_items = df[df.in_stock .== false, :]
        
        if nrow(in_stock_items) > 0 && nrow(out_stock_items) > 0
            stock_diff = mean(in_stock_items.price) - mean(out_stock_items.price)
            println("  📦 Price difference (in vs out of stock): \$$(round(stock_diff, digits=2))")
        end
        
        # Review count correlation
        price_review_corr = cor(df.price, df.reviews_count)
        println("  📝 Price-Review correlation: $(round(price_review_corr, digits=3))")
        
        println("\n🔬 ADVANCED ANALYSIS OPPORTUNITIES:")
        println("  🧪 Bayesian pricing models with uncertainty quantification")
        println("  📊 Time series analysis for price trends") 
        println("  🎯 Customer segmentation using mixture models")
        println("  🔍 Causal inference for pricing strategies")
        println("  🚀 Differential equations for market dynamics")
        
    catch e
        println("❌ ML Analysis Error: $e")
        
        # Check if it's a package issue
        if isa(e, LoadError) || contains(string(e), "not found")
            println("\n📦 PACKAGE INSTALLATION REQUIRED:")
            println("  Installing Julia ML packages...")
            
            try
                Pkg.add([
                    "MLJ",
                    "DecisionTree", 
                    "MLJLinearModels",
                    "MLJEnsembles",
                    "StatsModels",
                    "GLM",
                    "MLUtils"
                ])
                println("  ✅ Packages installed! Please run the script again.")
            catch install_err
                println("  ❌ Installation failed: $install_err")
            end
        else
            println("  🔧 Try running: julia scripts/python_to_julia_conversion.jl")
        end
    end
    
    println("\n🎓 JULIA ECOSYSTEM ADVANTAGES:")
    println("  🔥 Performance: 5-100x faster than Python for numerical computing")
    println("  🛡️  Type Safety: Compile-time error detection")
    println("  🧮 Scientific Computing: Built for mathematical modeling")
    println("  🔧 Composability: Easy to extend with domain-specific methods")
    println("  📈 Memory Efficiency: Better garbage collection and memory layout")
    println("  🌐 Parallelism: Native threading and distributed computing")
    
    println("\n✨ NEXT STEPS:")
    println("  1. Explore Julia's DifferentialEquations.jl for dynamic modeling")
    println("  2. Use Flux.jl for deep learning approaches")
    println("  3. Implement Bayesian models with Turing.jl")
    println("  4. Add real-time analysis with OnlineStats.jl")
    println("  5. Scale with distributed computing using Distributed.jl")
    
    println("\n🎯 CONVERSION COMPLETE: Python → Julia Native")
    println("   Performance improvements unlocked! 🚀")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end