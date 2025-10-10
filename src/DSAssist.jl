module DSAssist

using HTTP, JSON3, DataFrames, YAML
using CSV, Statistics
using Dates, UUIDs, Random

# Optional dependencies for notebooks
try
    using Plots
catch
    @warn "Plots.jl not available - plotting features disabled"
end

# Core modules
include("types.jl")
include("data/loader.jl")
include("utils/llm_client.jl")
include("knowledge/graph.jl")
include("execution/sandbox.jl")
include("evaluation/evaluator.jl")
include("agents/planning_agent.jl")
include("agents/codegen_agent.jl")
include("controllers/meta_controller.jl")

# Julia Native ML module
include("ml/julia_native_ml.jl")
using .JuliaNativeML

# Main exports
export create_experiment, run_autonomous_exploration, generate_report
export Experiment, ExperimentResult, AgentMessage
export run_experiment_cycle, MetaController

# Data handling exports
export load_csv_experiment, DataLoader

# Julia Native ML exports
export compare_ensemble_methods, random_forest_analysis, gradient_boosting_analysis,
       stacking_ensemble_analysis, bayesian_ensemble_analysis, load_and_prepare_data,
       encode_categorical_features, train_test_split_julia

# Agent exports
export PlanningAgent, CodeGenAgent, EvaluationAgent
export ExecutionSandbox, KnowledgeGraph

# Knowledge graph exports - Enhanced Intelligence
export update_knowledge, query_insights, query_techniques_for_domain, query_code_patterns,
       query_experiment_lineage, query_cross_domain_patterns, query_similarity_relationships,
       query_domain_statistics, 
       # Ensemble Intelligence
       query_ensemble_recommendations, extract_ensemble_intelligence, query_learning_intelligence,
       # Cognitive Intelligence  
       create_cognitive_intelligence

end # module DSAssist