# DSAssist: Agentic Data Science Workflows

This project implements a closed-loop agent system that mirrors a scientist's "tiny experiment" mindset for automated data science workflows.

## Core Architecture

### Agent Types & Responsibilities
- **Meta-Controller**: Orchestrates plan → code → execute → evaluate → reflect cycles
- **Planning Agent**: Breaks research questions into minimal subtasks using chain-of-thought
- **Code-Generation Agent**: Generates focused Python/Julia snippets with context awareness
- **Execution Environment**: Isolated containers/notebooks (Docker, Ray actors, Pluto.jl)
- **Evaluation Agent**: Parses outputs, compares metrics, decides success/failure/retry
- **Reflection Agent**: Updates knowledge graph and triggers next planning cycle

### Key Implementation Patterns

#### Microservice Communication
```python
# Agents communicate via message buses (Kafka/Redis streams)
# Each agent type deployed as lightweight Ray Serve/Kubernetes service
```

#### Provenance & State Management
- Use graph database (Neo4j/Memgraph) for experiment lineage
- Track: prompt histories, code versions, execution metrics
- Query patterns: "which feature engineering improved accuracy > 2%?"

#### Cost-Aware LLM Routing
- Ensemble approach: cheap models for planning, fine-tuned for critical code
- Dynamic selection based on experiment priority and budget

## Development Workflows

### Experiment Loop Structure
1. **Hypothesis Generation**: Use skeleton prompts for domain-specific tests
2. **Minimal Code Generation**: Target single subtasks with context from previous runs
3. **Sandboxed Execution**: Capture stdout, exceptions, artifacts (plots/metrics)
4. **Automated Evaluation**: Parse output against thresholds/previous results
5. **Knowledge Update**: Log outcomes, update meta-controller plans

### Testing & Debugging
- **Failure-Driven Development**: Evaluation agent requests targeted fixes for failing code
- **Exploration vs Exploitation**: Allocate fraction of loops to Bayesian parameter sampling
- **Auto-Documentation**: Generate Markdown summaries after each successful loop

## Project Conventions

### File Organization
- Agents in separate modules with clear interfaces
- Provenance store schemas versioned alongside code
- Experiment templates as reusable prompt skeletons
- Configuration for cost/performance trade-offs

### Language Preferences
- **Julia**: Scientific computing, Pluto.jl notebooks for interactive exploration
- **Python**: ML/data processing, Ray for distributed execution
- **Configuration**: YAML/TOML for agent parameters and LLM routing rules

### Integration Points
- **Container Orchestration**: Docker for isolation, Kubernetes for scaling
- **Message Queues**: Async communication between agent services
- **Artifact Storage**: Version-controlled outputs (models, plots, reports)
- **Monitoring**: Execution metrics, cost tracking, success rates

## Critical Developer Knowledge

### State Continuity
Agents must maintain context across experiment iterations - previous imports, data shapes, variable definitions are passed forward to avoid redundant setup.

### Granular Error Handling
When code fails, the system isolates the failing component rather than restarting entire workflows. Evaluation agents provide targeted feedback for incremental fixes.

### Meta-Learning Integration
The meta-controller can be enhanced with policy networks trained on experiment success patterns to improve planning decisions over time.

### Domain-Specific Extensions
Architecture supports pluggable agents for specialized domains (time series, NLP, computer vision) while maintaining the core experiment loop structure.