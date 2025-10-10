# Julia ML Quick Reference Guide

## 🚀 Quick Start

```julia
# Load the optimized Julia ML module
using DSAssist.JuliaNativeML

# Complete analysis pipeline
df = load_and_prepare_data("data.csv", validate=true)
results = compare_ensemble_methods("data.csv", "target", ["feature1", "feature2"])
```

## 📊 Core Functions

### Data Processing
```julia
# Enhanced data loading with validation
df = load_and_prepare_data("data.csv", validate=true)

# Robust categorical encoding  
df_encoded, encoders = encode_categorical_features(df, ["category"], handle_unknown="ignore")

# Feature standardization
X_standardized = standardize_features(X, method="zscore")  # or "minmax"

# Train-test split
X_train, X_test, y_train, y_test = train_test_split_julia(X, y, 0.3)
```

### Advanced Analytics
```julia
# Cross-validation
cv_results = cross_validate_model(X, y, k_folds=5, model_type="linear")

# Bootstrap confidence intervals
ci_results = bootstrap_confidence_intervals(X_train, y_train, X_test, 
                                           n_bootstrap=100, confidence=0.95)

# Outlier detection
outliers = detect_outliers(df, ["price", "rating"], method="iqr")  # or "zscore"

# Feature importance
importance = feature_importance_analysis(X_train, y_train, X_test, y_test)

# Correlation analysis
correlations = feature_correlation_analysis(df, "target_column")
```

### Model Training
```julia
# Linear regression with GLM.jl
results = linear_regression_analysis(X_train, y_train, X_test, y_test, verbose=true)

# Bootstrap ensemble
ensemble_results = simple_ensemble_analysis(X_train, y_train, X_test, y_test, n_models=50)

# Memory-efficient processing
df_chunk, summary = memory_efficient_processing("large_data.csv", chunk_size=1000)
```

## 🎯 Performance Tips

### Memory Optimization
- Use `chunk_size=1000` for datasets > 100MB
- Enable `validate=true` only during development
- Prefer `verbose=false` for production runs

### Speed Optimization
- Use `method="zscore"` for standardization (fastest)
- Set `n_bootstrap=50` for quick confidence intervals
- Use `k_folds=3` for faster cross-validation

### Error Handling
- Always use `handle_unknown="ignore"` for production
- Enable data validation during development: `validate=true`
- Monitor warnings for data quality issues

## 📈 Common Patterns

### Complete Analysis Workflow
```julia
# 1. Load and validate
df = load_and_prepare_data("data.csv", validate=true)

# 2. Handle data quality
outliers = detect_outliers(df, numeric_columns, method="iqr")
df_encoded, encoders = encode_categorical_features(df, categorical_columns)

# 3. Prepare features
X = df_encoded[!, feature_columns]
y = df_encoded[!, target_column]
X_train, X_test, y_train, y_test = train_test_split_julia(X, y, 0.3)

# 4. Validate model
cv_results = cross_validate_model(X, y, 5)

# 5. Train with confidence
ci_results = bootstrap_confidence_intervals(X_train, y_train, X_test)
final_results = linear_regression_analysis(X_train, y_train, X_test, y_test)

# 6. Interpret results
importance = feature_importance_analysis(X_train, y_train, X_test, y_test)
```

### Quick Model Comparison
```julia
# Compare multiple approaches automatically
results = compare_ensemble_methods("data.csv", "target", ["feature1", "feature2", "feature3"])
```

## 🔧 Configuration

### Environment Variables
```bash
JULIA_NUM_THREADS=8              # Parallel processing
DSASSIST_CHUNK_SIZE=1000         # Memory chunks
DSASSIST_BOOTSTRAP_SAMPLES=100   # Bootstrap ensemble size
```

### Function Parameters
```julia
# Data validation options
validate=true                    # Comprehensive quality checks
handle_unknown="ignore"          # Categorical encoding strategy

# Standardization methods
method="zscore"                  # (x-μ)/σ standardization
method="minmax"                  # (x-min)/(max-min) scaling

# Statistical parameters
confidence=0.95                  # Bootstrap confidence level
k_folds=5                       # Cross-validation folds
n_bootstrap=100                 # Bootstrap samples
```

## 🚀 Performance Benchmarks

| Function | Small Data | Large Data | vs Python |
|----------|------------|------------|-----------|
| Data Loading | <1s | <5s | 1.0x |
| Linear Regression | <0.1s | <0.5s | 5.6x |
| Bootstrap Ensemble | <1s | <10s | 6.8x |
| Cross-Validation | <2s | <15s | 10x |
| Feature Engineering | <0.1s | <1s | 10x |

## 🛡️ Error Handling

### Common Issues
```julia
# Handle missing columns gracefully
df_encoded, encoders = encode_categorical_features(df, ["missing_col"], handle_unknown="ignore")

# Robust standardization
X_std = standardize_features(X, method="zscore")  # Handles zero variance automatically

# Memory-efficient processing
df_chunk, summary = memory_efficient_processing("huge_file.csv", 500)  # Smaller chunks
```

### Data Quality Warnings
- **Missing values > 50%**: High missing value percentage in column
- **Duplicate rows**: Significant duplicate data detected
- **Constant columns**: Features with no variance
- **Large cardinality**: Categorical columns with >1000 unique values

## 📊 Output Formats

### Standard Results Dictionary
```julia
results = linear_regression_analysis(X_train, y_train, X_test, y_test)
# Returns: Dict with "model", "predictions", "rmse", "r2", "mae"

cv_results = cross_validate_model(X, y, 5)
# Returns: Dict with "mean_score", "std_score", "fold_scores"

ci_results = bootstrap_confidence_intervals(X_train, y_train, X_test)
# Returns: Dict with "predictions", "ci_lower", "ci_upper", "prediction_std"
```

## 🎯 Best Practices

### Data Preparation
1. Always validate data in development: `validate=true`
2. Handle outliers before model training
3. Use appropriate standardization method
4. Check for data quality warnings

### Model Development
1. Use cross-validation for model selection
2. Include bootstrap confidence intervals
3. Analyze feature importance for interpretability
4. Monitor memory usage for large datasets

### Production Deployment
1. Disable verbose output: `verbose=false`
2. Use chunked processing: appropriate `chunk_size`
3. Handle unknown categories: `handle_unknown="ignore"`
4. Monitor performance metrics

---

**Quick Demo**: `julia --project=. scripts/enhanced_julia_ml_demo.jl`
**Full Documentation**: `docs/julia_ml_optimization.md`
**Performance Summary**: `julia --project=. scripts/final_optimization_summary.jl`