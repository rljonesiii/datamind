"""
    CodeGenAgent

Generates focused Python/Julia code snippets to test specific hypotheses.
"""
struct CodeGenAgent
    config::AgentConfig
    llm_client::LLMClient
    
    function CodeGenAgent(config::Dict)
        agent_config = AgentConfig(
            "codegen_agent",
            get(config, "model", "gpt-4"),
            get(config, "temperature", 0.1),
            get(config, "max_tokens", 2000),
            get(config, "system_prompt", codegen_system_prompt()),
            get(config, "retry_count", 3)
        )
        
        llm_client = LLMClient(agent_config)
        new(agent_config, llm_client)
    end
end

"""
    generate_code(agent::CodeGenAgent, plan::Dict, experiment::Experiment)

Generates executable code based on the planning agent's output.
"""
function generate_code(agent::CodeGenAgent, plan::Dict, experiment::Experiment)
    context = build_code_context(experiment)
    
    prompt = """
    Generate Julia code to test this hypothesis:
    
    Hypothesis: $(plan["hypothesis"])
    Steps: $(join(plan["steps"], ", "))
    Expected Outcome: $(plan["expected_outcome"])
    Success Metrics: $(join(plan["success_metrics"], ", "))
    
    Context from previous iterations:
    $context
    
    Requirements:
    - Write complete, executable Julia code
    - Include necessary imports (using CSV, DataFrames, Statistics, etc.)
    - Load data from file if data_file is provided in context
    - Handle data loading/generation if needed
    - Calculate the specified success metrics
    - Print results clearly with metric names and values
    - Keep it under 50 lines
    - Use DataFrames, Plots, Statistics for data work
    - If working with CSV data, use CSV.read() to load it
    
    Return only the code, no explanations.
    """
    
    code = call_llm(agent.llm_client, prompt)
    return clean_code_response(code)
end

"""
    build_code_context(experiment::Experiment)

Builds context for code generation from previous successful attempts.
"""
function build_code_context(experiment::Experiment)
    context_parts = String[]
    
    # Include data file information
    if haskey(experiment.context, "data_file")
        push!(context_parts, "Data file: $(experiment.context["data_file"])")
        push!(context_parts, "Data shape: $(experiment.context["data_shape"])")
        
        if haskey(experiment.context, "columns")
            push!(context_parts, "Columns: $(join(experiment.context["columns"], ", "))")
        end
        
        if haskey(experiment.context, "numeric_columns") && !isempty(experiment.context["numeric_columns"])
            push!(context_parts, "Numeric columns: $(join(experiment.context["numeric_columns"], ", "))")
        end
        
        if haskey(experiment.context, "categorical_columns") && !isempty(experiment.context["categorical_columns"])
            push!(context_parts, "Categorical columns: $(join(experiment.context["categorical_columns"], ", "))")
        end
    end
    
    # Include successful patterns
    if haskey(experiment.context, "successful_patterns")
        push!(context_parts, "Previously successful imports/patterns:")
        for pattern in experiment.context["successful_patterns"]
            push!(context_parts, pattern)
        end
    end
    
    # Include variable definitions from previous runs
    if haskey(experiment.context, "variables")
        push!(context_parts, "Available variables: $(join(keys(experiment.context["variables"]), ", "))")
    end
    
    return join(context_parts, "\n")
end

"""
    clean_code_response(code::String)

Cleans LLM response to extract just the code.
"""
function clean_code_response(code::String)
    # Remove markdown code blocks
    cleaned = replace(code, r"```julia\n?" => "")
    cleaned = replace(cleaned, r"```\n?" => "")
    
    # Remove any explanatory text before/after code
    lines = split(cleaned, "\n")
    code_lines = String[]
    
    in_code = false
    for line in lines
        # Start collecting when we see import/using or function definitions
        if !in_code && (startswith(strip(line), "using") || 
                       startswith(strip(line), "import") ||
                       startswith(strip(line), "function") ||
                       contains(line, "=") && !startswith(strip(line), "#"))
            in_code = true
        end
        
        if in_code
            push!(code_lines, line)
        end
    end
    
    return join(code_lines, "\n")
end

"""
    codegen_system_prompt()

System prompt for the code generation agent.
"""
function codegen_system_prompt()
    return """
    You are an expert Julia programmer specializing in data science code generation.
    
    Your role is to write minimal, focused code that tests specific hypotheses.
    
    Key principles:
    - Write clean, executable Julia code
    - Use standard data science packages (DataFrames, Plots, StatsPlots, MLJ)
    - Include clear variable names and comments for key steps
    - Always calculate and print the requested metrics
    - Handle errors gracefully with try-catch when appropriate
    - Prefer simple approaches that can be quickly validated
    
    Always return ONLY the code, no explanations or markdown formatting.
    """
end