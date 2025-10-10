"""
    PlanningAgent

Breaks down research questions into actionable subtasks using chain-of-thought reasoning.
"""
struct PlanningAgent
    config::AgentConfig
    llm_client::LLMClient
    
    function PlanningAgent(config::Dict)
        agent_config = AgentConfig(
            "planning_agent",
            get(config, "model", "gpt-4"),
            get(config, "temperature", 0.3),
            get(config, "max_tokens", 1000),
            get(config, "system_prompt", planning_system_prompt()),
            get(config, "retry_count", 3)
        )
        
        llm_client = LLMClient(agent_config)
        new(agent_config, llm_client)
    end
end

"""
    generate_plan(agent::PlanningAgent, experiment::Experiment)

Generates a structured plan for the current experiment iteration.
"""
function generate_plan(agent::PlanningAgent, experiment::Experiment)
    context = build_planning_context(experiment)
    
    prompt = """
    Research Question: $(experiment.research_question)
    
    Current Context:
    $context
    
    Generate a minimal, testable hypothesis and the specific steps needed to test it.
    Focus on one small aspect that can be coded and executed quickly.
    
    Respond in JSON format:
    {
        "hypothesis": "Clear, testable hypothesis",
        "steps": ["step1", "step2", ...],
        "expected_outcome": "What success looks like",
        "data_requirements": ["required data/variables"],
        "success_metrics": ["metric1", "metric2"]
    }
    """
    
    response = call_llm(agent.llm_client, prompt)
    return JSON3.read(response, Dict)
end

"""
    build_planning_context(experiment::Experiment)

Builds contextual information for the planning agent.
"""
function build_planning_context(experiment::Experiment)
    context_parts = String[]
    
    # Previous iterations
    if !isempty(experiment.history)
        push!(context_parts, "Previous attempts:")
        for (i, hist) in enumerate(experiment.history)
            status = hist["success"] ? "✅" : "❌"
            push!(context_parts, "  $i. $status $(get(hist, "summary", "No summary"))")
        end
    end
    
    # Available context
    if haskey(experiment.context, "data_shape")
        push!(context_parts, "Data shape: $(experiment.context["data_shape"])")
    end
    
    if haskey(experiment.context, "successful_patterns")
        push!(context_parts, "Successful patterns:")
        for pattern in experiment.context["successful_patterns"]
            push!(context_parts, "  - $pattern")
        end
    end
    
    return join(context_parts, "\n")
end

"""
    planning_system_prompt()

System prompt for the planning agent.
"""
function planning_system_prompt()
    return """
    You are a data science planning agent. Your role is to break down complex research questions 
    into minimal, testable hypotheses that can be quickly coded and validated.
    
    Key principles:
    - Generate ONE focused hypothesis per iteration
    - Prefer simple approaches over complex ones
    - Each step should be codeable in <50 lines
    - Consider what data/variables are actually available
    - Build incrementally on previous successful attempts
    
    Always respond with valid JSON containing the required fields.
    """
end