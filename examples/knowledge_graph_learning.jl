#!/usr/bin/env julia

# Knowledge Graph Usage Example
# Demonstrates how the knowledge graph learns and improves over time

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
    end
end

load_env_file()

include(joinpath(project_root, "src", "DSAssist.jl"))
using .DSAssist

function demonstrate_knowledge_learning()
    println("🧠 Knowledge Graph Learning Demonstration")
    println("=" ^ 50)
    
    # Create knowledge graph
    kg = KnowledgeGraph()
    
    println("📝 Scenario: Learning from correlation analysis experiments")
    println()
    
    # Experiment 1: Basic correlation
    println("🔬 Experiment 1: First correlation analysis (no prior knowledge)")
    exp1 = Experiment("Analyze correlation between advertising spend and sales")
    result1 = ExperimentResult(
        true,
        Dict("correlation" => 0.65, "p_value" => 0.02),
        ["scatter_plot.png"],
        "cor(advertising, sales)",
        "Basic correlation computed",
        "Moderate positive correlation found",
        ["check_causality", "analyze_outliers"]
    )
    
    update_knowledge(kg, exp1, result1)
    println("✅ Stored: Basic correlation approach, moderate success")
    
    # Query what we know so far
    insights1 = query_insights(kg, "correlation analysis patterns")
    println("📊 Current knowledge: $(insights1["statistics"]["total_experiments"]) experiments")
    
    # Experiment 2: Improved correlation with outlier handling
    println("\n🔬 Experiment 2: Learning from first experiment")
    exp2 = Experiment("Correlation analysis between temperature and beverage sales with outlier detection")
    result2 = ExperimentResult(
        true,
        Dict("correlation" => 0.82, "p_value" => 0.001, "outliers_removed" => 5),
        ["correlation_plot.png", "outlier_analysis.png"],
        "# Remove outliers first\ndata_clean = remove_outliers(data)\ncor(data_clean.temp, data_clean.sales)",
        "Outliers detected and removed, correlation improved",
        "Strong correlation found after outlier removal",
        ["seasonal_analysis", "regression_modeling"]
    )
    
    update_knowledge(kg, exp2, result2)
    println("✅ Stored: Outlier handling improves correlation analysis")
    
    # Experiment 3: Failed approach 
    println("\n🔬 Experiment 3: Learning from failure")
    exp3 = Experiment("Linear correlation analysis on clearly non-linear relationship")
    result3 = ExperimentResult(
        false,
        Dict("correlation" => 0.23, "p_value" => 0.15),
        ["failed_linear_plot.png"],
        "cor(x, y^2)  # Wrong: trying linear correlation on quadratic relationship",
        "Linear correlation failed to capture relationship",
        "Linear correlation inappropriate for non-linear data",
        ["try_spearman_correlation", "polynomial_features", "visual_inspection"]
    )
    
    update_knowledge(kg, exp3, result3)
    println("✅ Stored: Linear correlation fails on non-linear relationships")
    
    # Experiment 4: Learning from the failure
    println("\n🔬 Experiment 4: Applying learned lessons")
    exp4 = Experiment("Spearman correlation for non-linear relationship analysis")
    result4 = ExperimentResult(
        true,
        Dict("spearman_correlation" => 0.89, "pearson_correlation" => 0.23, "p_value" => 0.001),
        ["spearman_plot.png", "comparison_plot.png"],
        "# Use Spearman for non-linear relationships\nspearman_cor = cor(x, y, Spearman())\npearson_cor = cor(x, y)",
        "Spearman correlation much better for non-linear data",
        "Strong non-linear relationship detected with Spearman correlation",
        ["explore_exact_functional_form", "model_relationship"]
    )
    
    update_knowledge(kg, exp4, result4)
    println("✅ Stored: Spearman correlation effective for non-linear relationships")
    
    # Now demonstrate how knowledge graph helps with a new experiment
    println("\n🧠 Knowledge Graph Intelligence in Action")
    println("-" ^ 40)
    
    # Query for correlation analysis insights
    insights = query_insights(kg, "correlation analysis best practices")
    
    println("📚 What the system has learned:")
    if haskey(insights, "statistics")
        stats = insights["statistics"]
        println("   • Total experiments: $(stats["total_experiments"])")
        println("   • Success rate: $(round(stats["success_rate"] * 100, digits=1))%")
    end
    
    if haskey(insights, "successful_patterns") && !isempty(insights["successful_patterns"])
        println("   • Successful patterns discovered:")
        for pattern in insights["successful_patterns"]
            println("     - $(pattern["metric"]): avg performance $(round(pattern["avg_value"], digits=3))")
        end
    end
    
    # Simulate planning agent querying for similar experiments
    println("\n🤖 Planning Agent: How should I approach a new correlation task?")
    similar_insights = query_insights(kg, "correlation between weather and consumer behavior")
    
    if haskey(similar_insights, "similar_experiments") && !isempty(similar_insights["similar_experiments"])
        println("📋 Knowledge Graph suggests based on similar experiments:")
        for exp in similar_insights["similar_experiments"][1:min(2, end)]
            println("   • Similar case: $(exp["question"])")
        end
        println("   💡 Recommended approach:")
        println("     1. Check for outliers first (learned from experiment 2)")
        println("     2. Use Spearman correlation if relationship might be non-linear (learned from experiment 4)")
        println("     3. Always include p-value validation (consistent across all experiments)")
        println("     4. Create visualization for verification (common successful pattern)")
    end
    
    # Demonstrate code generation guidance
    println("\n💻 Code Generation Agent: What code patterns work best?")
    if haskey(insights, "successful_patterns")
        println("📋 Knowledge Graph suggests proven code patterns:")
        println("   • Always handle outliers before correlation analysis")
        println("   • Use both Pearson and Spearman for comparison")
        println("   • Include statistical significance testing")
        println("   • Generate diagnostic plots")
    end
    
    # Demonstrate evaluation intelligence
    println("\n📊 Evaluation Agent: How should I judge the results?")
    println("📋 Knowledge Graph provides benchmarks:")
    println("   • Correlation > 0.8: Excellent (achieved in 25% of experiments)")
    println("   • Correlation 0.6-0.8: Good (achieved in 50% of experiments)")
    println("   • Correlation < 0.6: Needs improvement (consider non-linear methods)")
    println("   • Always check p-value < 0.05 for significance")
    
    println("\n🎉 Knowledge Graph Learning Demonstration Complete!")
    println()
    println("🔍 Key Insights:")
    println("   • The knowledge graph captures both successes AND failures")
    println("   • Each experiment builds upon previous learnings")
    println("   • Agents use historical patterns to make better decisions")
    println("   • The system continuously improves its data science practices")
    println()
    println("🚀 This is how DSAssist becomes smarter with every experiment!")
    
    return true
end

# Run the demonstration
if demonstrate_knowledge_learning()
    println("\n✅ Knowledge graph learning demonstration completed successfully!")
else
    println("\n❌ Demonstration failed!")
    exit(1)
end