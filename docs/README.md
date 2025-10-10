# DSAssist Documentation

## Table of Contents

- [Agent Architecture](architecture.md) - System design and agent communication  
- **Knowledge Graph**:
  - [Knowledge Graph Summary](knowledge_graph_summary.md) - Quick overview of why and how
  - [Knowledge Graph Usage](knowledge_graph_usage.md) - Comprehensive guide to learning and patterns
  - [Neo4j Integration](neo4j_integration.md) - External graph database setup and configuration
- [Configuration Guide](configuration.md) - Setting up agents, LLMs, and environments
- [API Reference](api.md) - Function and type documentation
- [Development Guide](development.md) - Contributing and extending the system
- [Examples](../examples/) - Usage examples and tutorials

## Quick Start

For immediate usage, see the main [README.md](../README.md) in the project root.

## Detailed Documentation

### Architecture Overview
DSAssist implements a multi-agent system where specialized agents collaborate to conduct autonomous data science experiments:

- **Meta-Controller**: Orchestrates the overall experiment lifecycle
- **Planning Agent**: Decomposes research questions into actionable subtasks
- **Code Generation Agent**: Creates executable Julia/Python code
- **Evaluation Agent**: Analyzes results and determines next steps
- **Knowledge Graph**: Maintains experiment history and learned patterns

### Core Workflows

1. **Experiment Initialization**: User provides research question
2. **Planning Phase**: Planning Agent creates subtask breakdown
3. **Code Generation**: CodeGen Agent writes executable experiments
4. **Execution**: Sandboxed environment runs generated code
5. **Evaluation**: Results analyzed for insights and next steps
6. **Iteration**: Cycle repeats until objectives are met

### Configuration
The system is configured through YAML files in the `config/` directory:
- `agents.yaml`: Agent behavior and LLM settings
- Environment variables in `.env` for API keys

See [Configuration Guide](configuration.md) for detailed setup instructions.