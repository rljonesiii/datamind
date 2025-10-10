# DSAssist Agent Architecture

## System Overview

DSAssist implements a closed-loop multi-agent system designed to mirror scientific experimentation workflows. The architecture follows a "tiny experiment" philosophy where each iteration focuses on minimal, testable hypotheses.

## Core Components

### Meta-Controller
**Location**: `src/controllers/meta_controller.jl`

The Meta-Controller serves as the orchestrator for the entire experiment lifecycle:

```julia
struct MetaController
    experiment::Experiment
    config::Dict
    knowledge_graph::KnowledgeGraph
    iteration_count::Int
end
```

**Responsibilities**:
- Manage experiment state and iterations
- Coordinate communication between agents
- Track experiment progress and termination conditions
- Maintain knowledge graph updates

### Agent Types

#### Planning Agent
**Location**: `src/agents/planning_agent.jl`

Decomposes research questions into actionable subtasks using chain-of-thought reasoning.

```julia
function plan_experiment(agent::PlanningAgent, research_question::String)
    # Uses LLM to break down research question
    # Returns structured plan with subtasks
end
```

**Key Features**:
- Context-aware planning based on previous iterations
- Domain-specific planning templates
- Hypothesis generation and validation

#### Code Generation Agent  
**Location**: `src/agents/codegen_agent.jl`

Generates executable Julia/Python code for specific analysis tasks.

```julia
function generate_code(agent::CodeGenAgent, task::String, context::Dict)
    # Generates focused code snippets
    # Includes error handling and output capture
end
```

**Key Features**:
- Context-aware code generation
- Library and function suggestions
- Error handling and debugging hints

#### Evaluation Agent
**Location**: `src/evaluation/evaluator.jl`

Analyzes experiment results and determines success/failure/next steps.

```julia
function evaluate_results(agent::EvaluationAgent, results::Dict)
    # Parses outputs and metrics
    # Decides on experiment continuation
end
```

**Key Features**:
- Metric parsing and comparison
- Result interpretation and insights
- Iteration termination decisions

## Communication Patterns

### Message Bus
Agents communicate through structured messages:

```julia
struct AgentMessage
    id::String
    from_agent::String
    to_agent::String
    message_type::String
    content::Dict
    timestamp::DateTime
end
```

### Data Flow

1. **Planning Phase**:
   ```
   User Input → Planning Agent → Structured Plan → Meta-Controller
   ```

2. **Execution Phase**:
   ```
   Plan → Code Gen Agent → Executable Code → Execution Sandbox → Results
   ```

3. **Evaluation Phase**:
   ```
   Results → Evaluation Agent → Insights → Knowledge Graph → Next Iteration
   ```

## Knowledge Management

### Knowledge Graph
**Location**: `src/knowledge/graph.jl`

Maintains experiment provenance and learned patterns:

```julia
struct KnowledgeGraph
    experiments::Dict{String, Experiment}
    relationships::Vector{Relationship}
    patterns::Vector{Pattern}
end
```

**Capabilities**:
- Track experiment lineage
- Store successful code patterns
- Query historical results
- Identify similar problems

### Provenance Tracking

Every experiment iteration creates provenance records:
- Input research question
- Generated plans and code
- Execution results and metrics
- Agent decisions and rationale

## Execution Environment

### Sandboxed Execution
**Location**: `src/execution/sandbox.jl`

Provides isolated execution for generated code:

```julia
function execute_with_timeout(code::String, timeout::Int=30)
    # Safe execution with resource limits
    # Captures stdout, stderr, and return values
end
```

**Security Features**:
- Resource limits (memory, CPU, time)
- Filesystem restrictions
- Network isolation
- Package management

## Configuration Architecture

### Agent Configuration
Agents are configured through YAML files:

```yaml
agents:
  planning:
    model: "gpt-4"
    temperature: 0.1
    max_tokens: 1000
  
  codegen:
    model: "gpt-3.5-turbo"
    temperature: 0.2
    max_tokens: 2000
```

### LLM Routing
Cost-aware model selection:
- Cheap models for planning and evaluation
- Expensive models for complex code generation
- Fallback chains for reliability

## Extension Points

### Custom Agents
Add new agent types by implementing the `Agent` interface:

```julia
abstract type Agent end

function process_message(agent::Agent, message::AgentMessage)
    # Custom processing logic
end
```

### Domain Adaptations
- Custom planning templates for specific domains
- Specialized evaluation criteria
- Domain-specific code libraries

### Integration Hooks
- External data sources
- Custom execution environments
- Third-party ML platforms

## Deployment Patterns

### Local Development
- Single-process execution
- Mock LLM responses for testing
- File-based knowledge storage

### Production Deployment
- Microservice architecture
- Distributed execution with Ray
- Graph database for knowledge storage
- Message queue for agent communication

## Performance Considerations

### Scalability
- Stateless agent design enables horizontal scaling
- Knowledge graph can be sharded by experiment type
- Execution sandbox supports parallel experiments

### Cost Optimization
- Model routing based on task complexity
- Caching of similar analyses
- Incremental learning from successful patterns

## Monitoring and Observability

### Metrics Collection
- Experiment success rates
- Agent response times  
- LLM token usage and costs
- Code execution statistics

### Debugging Support
- Message tracing between agents
- Execution logs and error capture
- Visual experiment flow representation