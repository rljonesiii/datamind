#!/usr/bin/env julia

# 🚀 STREAMLINED DSASSIST: Real API Analysis for Any Research Question
# This bypasses the complex iterative system and provides direct LLM insights

using Pkg
Pkg.activate(".")

# Get the script directory and navigate to project root
script_dir = dirname(@__FILE__)
project_root = dirname(script_dir)
cd(project_root)

# Load environment variables
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

include(joinpath(project_root, "src", "DataMind.jl"))
using .DataMind

# Import required components
using .DataMind: PlanningAgent, CodeGenAgent, EvaluationAgent
using .DataMind: AgentConfig, LLMClient, call_llm
using DataFrames, CSV, Statistics, StatsBase
import JSON3

# Command line interface
function main()
    println("🚀 DataMind: Direct LLM Analysis")
    println("=" ^ 50)
    
    # Get research question
    if length(ARGS) > 0
        research_question = join(ARGS, " ")
        println("📝 Research Question: $research_question")
    else
        println("📝 Enter your research question:")
        research_question = readline()
    end
    
    # Get CSV file path
    println("📂 Enter CSV file path (or press Enter for product_sales.csv):")
    csv_input = readline()
    csv_path = isempty(strip(csv_input)) ? "data/product_sales.csv" : strip(csv_input)
    
    if !isfile(csv_path)
        error("❌ File not found: $csv_path")
    end
    
    # Load and analyze data
    println("📊 Loading data from: $csv_path")
    df = CSV.read(csv_path, DataFrame)
    println("✅ Loaded $(nrow(df)) rows × $(ncol(df)) columns")
    
    # Generate data summary
    data_summary = generate_data_summary(df)
    
    # Create analysis agent
    agent_config = Dict(
        "model" => "gpt-4",
        "temperature" => 0.7,
        "max_tokens" => 2000,
        "system_prompt" => """You are an expert data scientist and business analyst. 
        Analyze data to provide comprehensive, actionable insights that directly answer the research question.
        Focus on practical recommendations and clear explanations."""
    )
    
    analysis_agent = PlanningAgent(agent_config)
    
    # Generate analysis prompt
    analysis_prompt = """
    RESEARCH QUESTION: $research_question
    
    DATA SUMMARY:
    $data_summary
    
    ANALYSIS REQUEST:
    Based on this data, provide a comprehensive analysis that directly addresses the research question.
    Include:
    
    1. KEY FINDINGS: What are the most important insights that answer the research question?
    
    2. DATA PATTERNS: What patterns, trends, or relationships are evident in the data?
    
    3. QUANTITATIVE INSIGHTS: Specific metrics, correlations, or statistical observations
    
    4. ACTIONABLE RECOMMENDATIONS: Concrete steps or decisions based on the findings
    
    5. ADDITIONAL CONSIDERATIONS: Limitations, assumptions, or areas for further investigation
    
    Format your response clearly with headers and bullet points for easy reading.
    Prioritize insights that directly answer the research question.
    """
    
    println("🧠 Generating comprehensive analysis...")
    println("⏱️  This may take 30-60 seconds for complex analysis...")
    
    # Get LLM analysis
    analysis_result = call_llm(analysis_agent.llm_client, analysis_prompt)
    
    # Display results
    println("\n" * "=" ^ 80)
    println("📊 ANALYSIS RESULTS")
    println("=" ^ 80)
    println("🎯 Research Question: $research_question")
    println("📁 Data Source: $csv_path")
    println("📈 Data Size: $(nrow(df)) rows × $(ncol(df)) columns")
    println("\n" * "-" ^ 80)
    println(analysis_result)
    println("\n" * "=" ^ 80)
    println("✅ Analysis Complete! Real insights generated using GPT-4.")
    
    return analysis_result
end

"""
Generate a comprehensive data summary for LLM analysis
"""
function generate_data_summary(df::DataFrame)
    summary_parts = String[]
    
    # Basic info
    push!(summary_parts, "DATASET OVERVIEW:")
    push!(summary_parts, "- Total Rows: $(nrow(df))")
    push!(summary_parts, "- Total Columns: $(ncol(df))")
    
    # Column information
    push!(summary_parts, "\nCOLUMN DETAILS:")
    for col_name in names(df)
        col_type = eltype(df[!, col_name])
        missing_count = sum(ismissing.(df[!, col_name]))
        missing_pct = round(missing_count / nrow(df) * 100, digits=1)
        push!(summary_parts, "- $col_name ($col_type): $missing_count missing ($(missing_pct)%)")
    end
    
    # Numeric columns summary
    numeric_cols = [col for col in names(df) if eltype(df[!, col]) <: Number]
    if !isempty(numeric_cols)
        push!(summary_parts, "\nNUMERIC SUMMARY:")
        for col in numeric_cols
            if !all(ismissing.(df[!, col]))
                vals = skipmissing(df[!, col])
                min_val = minimum(vals)
                max_val = maximum(vals)
                mean_val = round(mean(vals), digits=2)
                std_val = round(std(vals), digits=2)
                push!(summary_parts, "- $col: range=[$min_val, $max_val], mean=$mean_val, std=$std_val")
            end
        end
    end
    
    # Categorical columns summary
    categorical_cols = [col for col in names(df) if !(eltype(df[!, col]) <: Number)]
    if !isempty(categorical_cols)
        push!(summary_parts, "\nCATEGORICAL SUMMARY:")
        for col in categorical_cols
            unique_count = length(unique(skipmissing(df[!, col])))
            push!(summary_parts, "- $col: $unique_count unique values")
            
            # Show top values for categorical columns with reasonable number of categories
            if unique_count <= 20
                top_values = sort(collect(countmap(skipmissing(df[!, col]))), by=x->x[2], rev=true)[1:min(5, unique_count)]
                top_str = join(["$(k) ($(v))" for (k,v) in top_values], ", ")
                push!(summary_parts, "  Top values: $top_str")
            end
        end
    end
    
    return join(summary_parts, "\n")
end

# Run the analysis if this script is executed directly
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end