"""
    EvaluationAgent

Analyzes execution results and decides on next actions.
"""
struct EvaluationAgent
    config::AgentConfig
    llm_client::LLMClient
    
    function EvaluationAgent(config::Dict)
        agent_config = AgentConfig(
            "evaluation_agent",
            get(config, "model", "gpt-4"),
            get(config, "temperature", 0.2),
            get(config, "max_tokens", 1500),
            get(config, "system_prompt", evaluation_system_prompt()),
            get(config, "retry_count", 3)
        )
        
        llm_client = LLMClient(agent_config)
        new(agent_config, llm_client)
    end
end

"""
    EvaluationResult

Results of evaluating an experiment iteration.
"""
struct EvaluationResult
    success::Bool
    confidence::Float64
    metrics::Dict{String, Float64}
    summary::String
    next_actions::Vector{String}
    should_stop::Bool
end

"""
    evaluate_results(agent::EvaluationAgent, execution_result::ExecutionResult, experiment::Experiment)

Evaluates the results of code execution and determines next steps.
"""
function evaluate_results(agent::EvaluationAgent, execution_result::ExecutionResult, experiment::Experiment)
    
    prompt = """
    Evaluate this experiment iteration:
    
    Research Question: $(experiment.research_question)
    
    Execution Results:
    - Success: $(execution_result.success)
    - Output: $(execution_result.output)
    - Error: $(execution_result.error)
    - Artifacts: $(join(execution_result.artifacts, ", "))
    - Execution Time: $(execution_result.execution_time)s
    
    Previous Context:
    $(build_evaluation_context(experiment))
    
    Analyze these results and provide:
    1. Did this iteration succeed in testing the hypothesis?
    2. What specific insights were gained?
    3. How confident are you in the results (0.0-1.0)?
    4. What should be the next steps?
    5. Should we stop experimenting (if we have enough evidence)?
    
    Respond in JSON format:
    {
        "success": true/false,
        "confidence": 0.0-1.0,
        "metrics": {"metric_name": value, ...},
        "summary": "Brief summary of findings",
        "next_actions": ["action1", "action2", ...],
        "should_stop": true/false,
        "insights": ["insight1", "insight2", ...]
    }
    """
    
    response = call_llm(agent.llm_client, prompt)
    result_dict = JSON3.read(response, Dict)
    
    return EvaluationResult(
        result_dict["success"],
        result_dict["confidence"],
        get(result_dict, "metrics", Dict{String, Float64}()),
        result_dict["summary"],
        result_dict["next_actions"],
        result_dict["should_stop"]
    )
end

"""
    build_evaluation_context(experiment::Experiment)

Builds context for evaluation from experiment history.
"""
function build_evaluation_context(experiment::Experiment)
    context_parts = String[]
    
    # Previous iterations summary
    if !isempty(experiment.history)
        push!(context_parts, "Previous iterations:")
        for (i, hist) in enumerate(experiment.history)
            status = hist["success"] ? "✅" : "❌"
            metrics_str = isempty(hist["metrics"]) ? "No metrics" : join(["$(k): $(v)" for (k,v) in hist["metrics"]], ", ")
            push!(context_parts, "  $i. $status - $metrics_str")
        end
    end
    
    # Current metrics context
    if haskey(experiment.context, "last_metrics") && !isempty(experiment.context["last_metrics"])
        push!(context_parts, "Last successful metrics:")
        for (metric, value) in experiment.context["last_metrics"]
            push!(context_parts, "  - $metric: $value")
        end
    end
    
    # Iteration count
    iteration_count = get(experiment.context, "iteration_count", 0)
    push!(context_parts, "Current iteration: $(iteration_count + 1)")
    
    return join(context_parts, "\n")
end

"""
    evaluation_system_prompt()

System prompt for the evaluation agent.
"""
function evaluation_system_prompt()
    return """
    You are an expert data science evaluation agent. Your role is to critically analyze 
    experiment results and determine the quality and significance of findings.
    
    Key responsibilities:
    - Assess whether hypotheses were properly tested
    - Extract meaningful insights from outputs and artifacts
    - Identify when results are statistically significant
    - Determine when enough evidence has been gathered
    - Suggest focused next steps for continued exploration
    
    Evaluation criteria:
    - Successful execution indicates basic functionality
    - Look for quantitative metrics and statistical significance
    - Consider practical significance, not just statistical
    - Favor stopping when diminishing returns are evident
    - Recommend specific, actionable next steps
    
    Always respond with valid JSON containing all required fields.
    Be honest about limitations and uncertainty in the data.
    """
end

"""
    extract_metrics_from_output(output::String)

Attempts to extract numeric metrics from execution output.
"""
function extract_metrics_from_output(output::String)
    metrics = Dict{String, Float64}()
    
    # Look for common patterns like "accuracy: 0.95" or "mse = 0.23"
    patterns = [
        r"(\w+):\s*([0-9]+\.?[0-9]*)",
        r"(\w+)\s*=\s*([0-9]+\.?[0-9]*)",
        r"(\w+)\s+([0-9]+\.?[0-9]*)"
    ]
    
    for pattern in patterns
        for match in eachmatch(pattern, output)
            metric_name = lowercase(match.captures[1])
            metric_value = parse(Float64, match.captures[2])
            metrics[metric_name] = metric_value
        end
    end
    
    return metrics
end