# Core types for the DSAssist system
using Dates, UUIDs

"""
    ExperimentState

Tracks the current state of an experiment cycle.
"""
@enum ExperimentState begin
    PLANNING
    CODING
    EXECUTING
    EVALUATING
    REFLECTING
    COMPLETED
    FAILED
end

"""
    Experiment

Represents a data science experiment with its research question,
current state, and accumulated context.
"""
mutable struct Experiment
    id::String
    research_question::String
    state::ExperimentState
    context::Dict{String, Any}
    history::Vector{Dict{String, Any}}
    created_at::DateTime
    
    function Experiment(research_question::String)
        new(
            string(UUIDs.uuid4()),
            research_question,
            PLANNING,
            Dict{String, Any}(),
            Vector{Dict{String, Any}}(),
            Dates.now()
        )
    end
end

"""
    AgentMessage

Standard message format for inter-agent communication.
"""
struct AgentMessage
    from_agent::String
    to_agent::String
    message_type::String
    content::Dict{String, Any}
    timestamp::DateTime
    
    function AgentMessage(from::String, to::String, type::String, content::Dict)
        new(from, to, type, content, Dates.now())
    end
end

"""
    ExperimentResult

Contains the outcomes of an experiment iteration.
"""
struct ExperimentResult
    success::Bool
    metrics::Dict{String, Float64}
    artifacts::Vector{String}  # File paths to generated plots, models, etc.
    code_generated::String
    execution_output::String
    evaluation_summary::String
    next_actions::Vector{String}
end

"""
    AgentConfig

Configuration for individual agents.
"""
struct AgentConfig
    name::String
    llm_model::String
    temperature::Float64
    max_tokens::Int
    system_prompt::String
    retry_count::Int
end