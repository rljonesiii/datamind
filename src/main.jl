#!/usr/bin/env julia

using Pkg
Pkg.activate(".")

include("DataMind.jl")
using .DataMind
using YAML

"""
Main entry point for DataMind system.
"""
function main()
    println("🧪 DataMind: Agentic Data Science Workflows")
    println("=" ^ 50)
    
    # Load configuration
    config = YAML.load_file("config/agents.yaml")
    
    # Check if user wants to load a CSV file
    println("Do you want to load a CSV file? (y/n): ")
    load_csv = strip(readline())
    
    if lowercase(load_csv) == "y" || lowercase(load_csv) == "yes"
        println("Enter the path to your CSV file: ")
        csv_path = strip(readline())
        
        if !isempty(csv_path) && isfile(csv_path)
            println("Enter your research question (optional): ")
            research_question = strip(readline())
            
            # Create CSV experiment
            experiment = load_csv_experiment(String(csv_path), String(research_question))
            if experiment === nothing
                return 1
            end
        else
            println("❌ File not found or invalid path. Using manual research question.")
            println("Enter your research question:")
            research_question = readline()
            experiment = Experiment(research_question)
        end
    else
        # Get research question from user
        println("Enter your research question:")
        research_question = readline()
        
        if isempty(strip(research_question))
            research_question = "What patterns exist in this dataset?"
        end
        
        experiment = Experiment(research_question)
    end
    
    println("\n🎯 Research Question: $(experiment.research_question)")
    println("🤖 Starting autonomous exploration...\n")
    
    # Initialize meta-controller
    controller = MetaController(experiment, config)
    
    # Run experiment cycle
    try
        println("🚀 Starting experiment cycle with $(config["experiment"]["max_iterations"]) max iterations...")
        results = run_experiment_cycle(controller, config["experiment"]["max_iterations"])
        
        # Generate final report
        generate_final_report(experiment, results)
        
    catch e
        println("❌ Experiment failed with error: $e")
        println("📍 Error type: $(typeof(e))")
        
        # Print stack trace for debugging
        if isa(e, InterruptException)
            println("⚠️  Execution was interrupted by user")
        else
            println("📜 Stack trace:")
            for (exc, bt) in Base.catch_stack()
                showerror(stdout, exc, bt)
                println()
            end
        end
        return 1
    end
    
    return 0
end

"""
    generate_final_report(experiment::Experiment, results::Vector{ExperimentResult})

Generates a comprehensive report of experiment findings.
"""
function generate_final_report(experiment::Experiment, results::Vector{ExperimentResult})
    println("\n" * "=" ^ 60)
    println("📊 EXPERIMENT REPORT")
    println("=" ^ 60)
    
    println("Research Question: $(experiment.research_question)")
    println("Total Iterations: $(length(results))")
    println("Final State: $(experiment.state)")
    
    successful_iterations = count(r -> r.success, results)
    println("Successful Iterations: $successful_iterations/$(length(results))")
    
    if !isempty(results)
        final_result = results[end]
        println("\nFinal Results:")
        println("- Success: $(final_result.success)")
        
        if !isempty(final_result.metrics)
            println("- Key Metrics:")
            for (metric, value) in final_result.metrics
                println("  * $metric: $value")
            end
        end
        
        println("- Summary: $(final_result.evaluation_summary)")
        
        if !isempty(final_result.artifacts)
            println("- Generated Artifacts:")
            for artifact in final_result.artifacts
                println("  * $artifact")
            end
        end
        
        if !isempty(final_result.next_actions)
            println("\nRecommended Next Steps:")
            for (i, action) in enumerate(final_result.next_actions)
                println("  $i. $action")
            end
        end
    end
    
    println("\n" * "=" ^ 60)
end

# Public API functions
"""
    create_experiment(research_question::String)

Creates a new experiment with the given research question.
"""
function create_experiment(research_question::String)
    return Experiment(research_question)
end

"""
    load_csv_experiment(filepath::String, research_question::String="")

Creates an experiment from a CSV file with automatic data analysis.
"""
function load_csv_experiment(filepath::String, research_question::String="")
    println("📁 Loading CSV file: $filepath")
    
    try
        # Load the CSV and get basic info
        df, info = DataLoader.load_csv(filepath)
        
        # Display summary
        println(DataLoader.generate_data_summary(info))
        
        # Generate default research question if none provided
        if isempty(research_question)
            research_question = "What insights can be discovered in this dataset with $(info["shape"][1]) rows and $(info["shape"][2]) columns?"
        end
        
        # Create experiment
        experiment = Experiment(research_question)
        
        # Add data context to experiment
        experiment.context["data_file"] = filepath
        experiment.context["data_info"] = info
        experiment.context["data_shape"] = info["shape"]
        experiment.context["columns"] = info["columns"]
        
        # Extract numeric and categorical columns safely
        numeric_columns = String[]
        categorical_columns = String[]
        
        for (i, col_name) in enumerate(info["columns"])
            col_type = info["column_types"][i]
            if col_type <: Number
                push!(numeric_columns, col_name)
            else
                push!(categorical_columns, col_name)
            end
        end
        
        experiment.context["numeric_columns"] = numeric_columns
        experiment.context["categorical_columns"] = categorical_columns
        
        println("\n✅ Experiment created with data context")
        return experiment
        
    catch e
        println("❌ Error loading CSV: $e")
        return nothing
    end
end

"""
    run_autonomous_exploration(experiment::Experiment; max_iterations::Int=10)

Runs autonomous exploration on the given experiment.
"""
function run_autonomous_exploration(experiment::Experiment; max_iterations::Int=10)
    config = YAML.load_file("config/agents.yaml")
    controller = MetaController(experiment, config)
    return run_experiment_cycle(controller, max_iterations)
end

"""
    generate_report(results::Vector{ExperimentResult})

Generates a report from experiment results.
"""
function generate_report(results::Vector{ExperimentResult})
    if isempty(results)
        println("No results to report.")
        return
    end
    
    println("Experiment Summary:")
    println("- Total iterations: $(length(results))")
    println("- Successful: $(count(r -> r.success, results))")
    
    if results[end].success
        println("- Final metrics: $(results[end].metrics)")
    end
end

# Run main if this file is executed directly
if abspath(PROGRAM_FILE) == @__FILE__
    exit(main())
end