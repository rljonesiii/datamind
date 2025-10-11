#!/usr/bin/env julia

# Enhanced Knowledge Graph Ontology Demonstration

using Pkg
Pkg.activate(".")

# Get the script directory and navigate to project root
script_dir = dirname(@__FILE__)
project_root = dirname(script_dir)
cd(project_root)

# Load environment utilities
include("../src/utils/env_utils.jl")
load_env_file()

include(joinpath(project_root, "src", "DataMind.jl"))
using .DataMind

function demonstrate_enhanced_ontology()
    println("🧠 Enhanced Knowledge Graph Ontology Demonstration")
    println("=" ^ 60)
    
    # Create knowledge graph
    kg = KnowledgeGraph()
    
    if kg.neo4j_backend === nothing
        println("⚠️  Neo4j not available, using in-memory backend")
        println("📝 Enhanced ontology features require Neo4j backend")
        return false
    end
    
    println("✅ Neo4j backend active - demonstrating enhanced ontology")
    println()
    
    # Create diverse experiments to showcase relationships
    experiments_data = [
        # Correlation analysis experiments
        (
            "Correlation analysis between advertising spend and sales revenue",
            Dict("correlation" => 0.78, "p_value" => 0.002, "r_squared" => 0.61),
            ["correlation_plot.png", "model.jld2"],
            "using Statistics; cor_result = cor(advertising, sales); r_squared = cor_result^2",
            "Strong positive correlation found between advertising and sales",
            ["explore_causality", "seasonal_analysis"]
        ),
        
        # Machine learning classification
        (
            "Random forest classification for customer churn prediction",
            Dict("accuracy" => 0.89, "precision" => 0.85, "recall" => 0.87, "f1_score" => 0.86),
            ["confusion_matrix.png", "feature_importance.png", "rf_model.pkl"],
            "using MLJ; rf = RandomForestClassifier(); model = fit!(rf, X, y)",
            "Random forest achieved high accuracy for churn prediction",
            ["hyperparameter_tuning", "feature_selection"]
        ),
        
        # Time series analysis
        (
            "Time series forecasting of stock prices using ARIMA",
            Dict("mape" => 0.12, "rmse" => 15.6, "mae" => 12.3),
            ["forecast_plot.png", "residuals.png", "arima_model.jld2"],
            "using TSAnalysis; arima_model = fit(ARIMA(1,1,1), ts_data)",
            "ARIMA model provides reasonable forecasting accuracy",
            ["try_lstm", "ensemble_methods"]
        ),
        
        # NLP sentiment analysis
        (
            "Sentiment analysis of customer reviews using transformer models",
            Dict("accuracy" => 0.92, "precision" => 0.90, "recall" => 0.89),
            ["sentiment_distribution.png", "transformer_model.pkl"],
            "using Transformers; model = load_model('bert-sentiment'); predictions = predict(model, reviews)",
            "Transformer model achieves state-of-the-art sentiment classification",
            ["fine_tune_model", "error_analysis"]
        ),
        
        # Statistical hypothesis testing
        (
            "A/B testing analysis for website conversion rates",
            Dict("conversion_rate_a" => 0.12, "conversion_rate_b" => 0.15, "p_value" => 0.003, "effect_size" => 0.25),
            ["ab_test_plot.png", "statistical_report.pdf"],
            "using HypothesisTests; t_test_result = TTest(group_a, group_b)",
            "Statistically significant improvement in conversion rate for variant B",
            ["power_analysis", "long_term_monitoring"]
        )
    ]
    
    # Create experiments with rich metadata
    println("📝 Creating diverse experiments with rich ontology...")
    experiment_objects = []
    
    for (i, (question, metrics, artifacts, code, summary, next_actions)) in enumerate(experiments_data)
        experiment = Experiment(question)
        result = ExperimentResult(
            true,  # success
            metrics,
            artifacts,
            code,
            "Execution completed successfully",
            summary,
            next_actions
        )
        
        update_knowledge(kg, experiment, result)
        push!(experiment_objects, (experiment, result))
        
        println("   ✅ Experiment $i: $(question[1:min(50, end)])...")
    end
    
    println("\n🔍 Demonstrating Enhanced Query Capabilities")
    println("-" ^ 50)
    
    # 1. Query techniques by domain
    println("\n1️⃣ Techniques for Correlation Analysis Domain:")
    correlation_techniques = query_techniques_for_domain(kg.neo4j_backend, "correlation")
    if !isempty(correlation_techniques)
        for tech in correlation_techniques[1:min(3, end)]
            println("   • $(tech["technique"]) (Category: $(tech["category"]), Success Count: $(tech["success_count"]))")
        end
    else
        println("   • No domain-specific techniques found yet")
    end
    
    # 2. Query code patterns
    println("\n2️⃣ Successful Code Patterns:")
    code_patterns = query_code_patterns(kg.neo4j_backend)
    if !isempty(code_patterns)
        for pattern in code_patterns[1:min(3, end)]
            println("   • $(pattern["pattern_name"]): $(pattern["template"])")
            println("     Success Rate: $(round(pattern["success_rate"] * 100, digits=1))%, Used $(pattern["total_usage"]) times")
        end
    else
        println("   • No code patterns detected yet")
    end
    
    # 3. Query experiment lineage
    if !isempty(experiment_objects)
        first_exp = experiment_objects[1][1]
        println("\n3️⃣ Experiment Lineage for: $(first_exp.research_question[1:50])...")
        lineage = query_experiment_lineage(kg.neo4j_backend, first_exp.id)
        if !isempty(lineage)
            println("   • Domains: $(join(get(lineage, "domains", []), ", "))")
            println("   • Techniques Used: $(join(get(lineage, "techniques_used", []), ", "))")
            similar_count = length(get(lineage, "similar_experiments", []))
            println("   • Similar Experiments: $similar_count found")
        end
    end
    
    # 4. Query cross-domain patterns
    println("\n4️⃣ Cross-Domain Transfer Learning Opportunities:")
    cross_patterns = query_cross_domain_patterns(kg.neo4j_backend)
    if !isempty(cross_patterns)
        for pattern in cross_patterns[1:min(3, end)]
            println("   • $(pattern["pattern_name"]) works in both $(pattern["domain1"]) and $(pattern["domain2"])")
            println("     Cross-domain usage: $(pattern["cross_domain_usage"]) times")
        end
    else
        println("   • No cross-domain patterns found yet (need more diverse experiments)")
    end
    
    # 5. Advanced similarity analysis
    println("\n5️⃣ Advanced Similarity Relationships:")
    similarities = query_similarity_relationships(kg.neo4j_backend, 5)
    if !isempty(similarities)
        for sim in similarities
            println("   • Similarity $(round(sim["similarity_score"], digits=3)): ")
            println("     - $(sim["exp1_question"][1:min(40, end)])...")
            println("     - $(sim["exp2_question"][1:min(40, end)])...")
        end
    else
        println("   • No similarity relationships found yet")
    end
    
    # 6. Domain statistics
    println("\n6️⃣ Domain Knowledge Distribution:")
    domains = query_domain_statistics(kg.neo4j_backend)
    if !isempty(domains)
        for domain in domains
            println("   • $(domain["domain_name"]): $(domain["experiment_count"]) experiments")
        end
    else
        println("   • No domain data found")
    end
    
    println("\n🎉 Enhanced Ontology Demonstration Complete!")
    println()
    println("🔍 Key Enhancements Demonstrated:")
    println("   • Rich node types: Domains, Techniques, CodePatterns")
    println("   • Multiple relationship types: BELONGS_TO_DOMAIN, APPLIES_TECHNIQUE, USES_PATTERN, SIMILAR_TO")
    println("   • Advanced queries: Cross-domain patterns, technique effectiveness, code reuse")
    println("   • Semantic understanding: Domain classification, technique categorization")
    println("   • Transfer learning: Patterns that work across different domains")
    println()
    println("🚀 This creates a truly intelligent knowledge system that goes far beyond")
    println("   simple experiment logging to capture the deep structure of data science knowledge!")
    
    return true
end

# Run the demonstration
if demonstrate_enhanced_ontology()
    println("\n✅ Enhanced ontology demonstration completed successfully!")
else
    println("\n❌ Demonstration failed or requires Neo4j backend!")
    exit(1)
end