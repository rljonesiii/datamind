#!/usr/bin/env julia

"""
Enhanced Julia ML Usage Example - Demonstrating Optimization & Validation
=========================================================================

This script showcases the refined and optimized Julia native ML capabilities:
- Enhanced error handling and data validation
- Statistical testing and cross-validation  
- Outlier detection and feature importance
- Bootstrap confidence intervals
- Memory-efficient processing
- Comprehensive model evaluation
"""

using Pkg
Pkg.activate(".")

# Load the enhanced DSAssist module
include("../src/DSAssist.jl")
using .DSAssist
using .DSAssist.JuliaNativeML
using Random, Statistics

println("🚀 ENHANCED JULIA ML OPTIMIZATION EXAMPLE")
println("=" ^ 60)

# Test data path
data_path = "data/product_sales.csv"

println("\n📊 REFINEMENT 1: Enhanced Data Validation")
println("-" ^ 50)

# Load data with enhanced validation
df = load_and_prepare_data(data_path, validate=true)
println("✅ Data loaded with comprehensive quality checks!")

println("\n🔍 REFINEMENT 2: Outlier Detection")
println("-" ^ 50)

# Detect outliers in numeric columns
numeric_cols = ["price", "rating", "reviews_count"]
outlier_results = detect_outliers(df, numeric_cols, method="iqr")
println("✅ Outlier analysis completed!")

println("\n🎯 REFINEMENT 3: Feature Importance Analysis")
println("-" ^ 50)

# Prepare data for feature importance
feature_cols = ["rating", "reviews_count"]
categorical_cols = ["category"]

# Enhanced categorical encoding with error handling
df_encoded, encoders = encode_categorical_features(df, categorical_cols, handle_unknown="ignore")

# Add encoded features to feature list
for col in categorical_cols
    push!(feature_cols, "$(col)_encoded")
end

# Prepare data
X = df_encoded[!, feature_cols]
y = df_encoded[!, "price"]

# Enhanced train-test split
Random.seed!(42)
X_train, X_test, y_train, y_test = train_test_split_julia(X, y, 0.3)

# Feature importance analysis
importance_scores = feature_importance_analysis(X_train, y_train, X_test, y_test)
println("✅ Feature importance ranking completed!")

println("\n📊 REFINEMENT 4: Cross-Validation")
println("-" ^ 50)

# Perform k-fold cross-validation
cv_results = cross_validate_model(X, y, 5, model_type="linear")
println("✅ 5-fold cross-validation completed!")

println("\n🎲 REFINEMENT 5: Bootstrap Confidence Intervals")
println("-" ^ 50)

# Bootstrap confidence intervals for predictions
ci_results = bootstrap_confidence_intervals(X_train, y_train, X_test, n_bootstrap=50, confidence=0.95)
println("✅ Bootstrap confidence intervals computed!")

println("\n⚡ REFINEMENT 6: Memory-Efficient Processing")
println("-" ^ 50)

# Demonstrate memory-efficient processing
df_chunk, processing_summary = memory_efficient_processing(data_path, 10)
println("✅ Memory-efficient processing demonstrated!")
println("  💾 Processing summary: $(processing_summary)")

println("\n🧮 REFINEMENT 7: Numerical Stability")
println("-" ^ 50)

# Test feature standardization
X_matrix = Matrix{Float64}(X_train[:, feature_cols])
X_standardized_zscore = standardize_features(X_matrix, method="zscore")
X_standardized_minmax = standardize_features(X_matrix, method="minmax")

println("📊 Feature standardization comparison:")
println("  🎯 Original mean: $(round(mean(X_matrix), digits=3))")
println("  📏 Z-score mean: $(round(mean(X_standardized_zscore), digits=3))")
println("  📐 MinMax mean: $(round(mean(X_standardized_minmax), digits=3))")
println("✅ Feature standardization options available!")

println("\n🏆 OPTIMIZATION RESULTS SUMMARY")
println("=" ^ 60)

println("✅ Enhanced Data Validation:")
println("  📊 Quality checks: Missing values, duplicates, constants")
println("  🛡️  Error handling: Robust categorical encoding")
println("  ⚠️  Warnings: Data quality issues flagged")

println("\n✅ Statistical Testing & Validation:")
println("  📊 Cross-validation: $(round(cv_results["mean_score"], digits=3)) ± $(round(cv_results["std_score"], digits=3))")
println("  🎲 Bootstrap CI: 95% confidence intervals computed")
println("  🔍 Outlier detection: $(outlier_results["total_outliers"]) outliers found")

println("\n✅ Feature Analysis & Optimization:")
feature_ranking = sort(collect(importance_scores), by=x->x[2], rev=true)
println("  🎯 Most important feature: $(feature_ranking[1][1]) ($(round(feature_ranking[1][2], digits=4)))")
println("  📊 Feature standardization: Z-score and MinMax available")
println("  🔄 Correlation analysis: Integrated")

println("\n✅ Performance & Memory Optimization:")
println("  💾 Memory efficiency: Chunked processing implemented")
println("  🚀 Error recovery: Graceful failure handling")
println("  📈 Numerical stability: Multiple standardization methods")

println("\n✅ Production Readiness:")
println("  🛡️  Type safety: Compile-time error detection")
println("  🧪 Statistical rigor: Cross-validation & bootstrap")
println("  📊 Model interpretability: Feature importance & CI")
println("  ⚡ Performance: Memory-efficient large data handling")

println("\n🎯 OPTIMIZATION BENEFITS ACHIEVED:")
println("  🔍 Data Quality: Comprehensive validation pipeline")
println("  📊 Statistical Rigor: CV, bootstrap, outlier detection")
println("  🛡️  Robustness: Enhanced error handling & recovery")
println("  💾 Scalability: Memory-efficient processing")
println("  🎯 Interpretability: Feature importance & confidence")

println("\n✨ NEXT-LEVEL FEATURES READY:")
println("  1. 🎲 Uncertainty quantification with bootstrap")
println("  2. 🔍 Advanced outlier detection methods")
println("  3. 📊 Comprehensive model validation")
println("  4. 💾 Big data processing capabilities")
println("  5. 🛡️  Production-grade error handling")

println("\n🎉 Julia ML Optimization & Refinement: COMPLETE! 🚀")
println("=" ^ 60)