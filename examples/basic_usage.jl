using DSAssist

# Example 1: Simple correlation analysis
function example_correlation_analysis()
    println("🔍 Example: Correlation Analysis")
    
    experiment = create_experiment("Do height and weight correlate in adults?")
    results = run_autonomous_exploration(experiment, max_iterations=5)
    generate_report(results)
end

# Example 2: Predictive modeling
function example_predictive_modeling() 
    println("🔍 Example: Predictive Modeling")
    
    experiment = create_experiment("Can we predict house prices from basic features?")
    results = run_autonomous_exploration(experiment, max_iterations=8)
    generate_report(results)
end

# Example 3: Data quality assessment
function example_data_quality()
    println("🔍 Example: Data Quality Assessment")
    
    experiment = create_experiment("What data quality issues exist in this dataset?")
    results = run_autonomous_exploration(experiment, max_iterations=3)
    generate_report(results)
end

# Run examples
if abspath(PROGRAM_FILE) == @__FILE__
    example_correlation_analysis()
    println("\n" * "="^50 * "\n")
    example_predictive_modeling()
    println("\n" * "="^50 * "\n") 
    example_data_quality()
end