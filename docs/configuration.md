# DataMind Configuration Guide

## Overview

DataMind uses YAML configuration files and environment variables to configure agent behavior, LLM routing, and system parameters. The system features **real GPT-4 integration** with 177+ experiments tracked and **Julia native ML optimization** for maximum performance.

## 🔧 **Quick Setup**

### 1. **Environment Setup**
```bash
# Required: OpenAI API key for real LLM integration
echo "OPENAI_API_KEY=your_actual_api_key_here" > .env

# Optional: Additional providers
echo "ANTHROPIC_API_KEY=your_claude_key" >> .env

# Optional: Performance tuning
echo "JULIA_NUM_THREADS=4" >> .env
```

### 2. **Enhanced Script Runner**
```bash
cd scripts/
./run.sh --help                                              # See all available options
./run.sh demos/agentic_guided_tour/basic_usage.jl           # Test basic workflow
./run.sh test/integration_test.jl                           # Verify full system
```

## ⚙️ **Configuration Files**

### `config/agents.yaml`

Main configuration file with enhanced agent intelligence and real LLM integration:

```yaml
# Enhanced Agent Configuration with Real LLM Integration
agents:
  planning:
    model: "gpt-4"                    # Real GPT-4 for intelligent planning
    temperature: 0.3                  # Balanced creativity/consistency
    max_tokens: 1000
    system_prompt: "You are an intelligent scientific planning agent with access to 177+ experiment patterns..."
  
  codegen:
    model: "gpt-4"                    # Real GPT-4 for advanced code generation
    temperature: 0.2                  # Lower temperature for code precision
    max_tokens: 2000
    system_prompt: "You generate optimized Julia code using native ML for maximum performance..."
  
  evaluation:
    model: "gpt-4"                    # Real GPT-4 for intelligent evaluation
    temperature: 0.1                  # Consistent evaluation criteria
    max_tokens: 1500
    system_prompt: "You evaluate experiment results with statistical rigor and domain expertise..."

# Enhanced Experiment Settings
experiment:
  max_iterations: 10
  timeout_seconds: 300
  auto_save: true
  knowledge_graph: true              # Enable Neo4j learning
  vector_database: true              # Enable ChromaDB semantic search
  
# Julia Native Execution Environment
execution:
  timeout: 60                        # Extended for complex Julia ML operations
  memory_limit: "4GB"                # Increased for large dataset processing
  enable_plots: true
  julia_native_ml: true              # Enable 5-100x performance optimizations
  
# Real LLM Configuration
llm:
  provider: "openai"
  base_url: "https://api.openai.com/v1"
  timeout: 60                        # Extended for complex reasoning
  real_api_calls: true               # Default: real API integration
  retries: 3
  use_real_api: true  # Default: true (real API calls), set to false for mock responses
```

### Environment Variables (`.env`)

Sensitive configuration like API keys:

```bash
# OpenAI API Configuration
OPENAI_API_KEY=your_openai_api_key_here
OPENAI_ORG_ID=your_organization_id  # optional

# Alternative LLM Providers
ANTHROPIC_API_KEY=your_anthropic_key  # for Claude models
AZURE_OPENAI_KEY=your_azure_key      # for Azure OpenAI

# API Behavior Control
DSASSIST_USE_MOCK_API=false  # Set to true for development/testing with mock responses

# System Configuration
LOG_LEVEL=INFO
DEBUG_MODE=false
EXPERIMENT_DIR=experiments
```

## Agent Configuration

### Planning Agent

Controls how research questions are decomposed into subtasks:

- **model**: LLM model for planning (recommend GPT-4 for complex reasoning)
- **temperature**: Creativity level (0.1 = focused, 0.8 = creative)
- **max_tokens**: Maximum response length
- **system_prompt**: Instructions for planning behavior

### Code Generation Agent

Controls code generation for experiments:

- **model**: LLM model for code generation (GPT-3.5-turbo is cost-effective)
- **temperature**: Code consistency (keep low ~0.2)
- **context_window**: How much previous context to include

### Evaluation Agent

Controls result analysis and iteration decisions:

- **model**: LLM for evaluation (GPT-3.5-turbo sufficient)
- **success_threshold**: Minimum score to consider experiment successful
- **failure_patterns**: Common failure patterns to detect

## LLM Provider Configuration

### OpenAI

Default provider with GPT models:

```yaml
llm:
  provider: "openai"
  base_url: "https://api.openai.com/v1"
  models:
    planning: "gpt-4"
    codegen: "gpt-3.5-turbo"
    evaluation: "gpt-3.5-turbo"
```

### Local Models

For privacy or cost considerations:

```yaml
llm:
  provider: "local"
  base_url: "http://localhost:8000/v1"
  models:
    planning: "llama2-70b"
    codegen: "codellama-34b"
    evaluation: "llama2-13b"
```

### Mock Responses

For development and testing (now opt-in):

```yaml
# Method 1: Environment variable (recommended for testing)
# Set DSASSIST_USE_MOCK_API=true

# Method 2: Configuration file
llm:
  use_mock_responses: true
  mock_delay: 1.0  # seconds to simulate API delay
```

**Note**: As of the latest version, DSAssist defaults to real API calls. Set `DSASSIST_USE_MOCK_API=true` for testing with mock responses.

## Execution Environment

### Resource Limits

Control resource usage for generated code:

```yaml
execution:
  timeout: 30          # seconds
  memory_limit: "1GB"  # RAM limit
  cpu_limit: 2         # CPU cores
  enable_network: false # disable network access
```

### Package Management

Control available packages:

```yaml
execution:
  allowed_packages:
    - "CSV"
    - "DataFrames" 
    - "Statistics"
    - "Plots"
  forbidden_operations:
    - "run"      # disable shell commands
    - "download" # disable file downloads
```

## Experiment Settings

### Iteration Control

```yaml
experiment:
  max_iterations: 10        # maximum experiment cycles
  min_iterations: 3         # minimum before early stopping
  success_threshold: 0.8    # score to consider complete
  improvement_threshold: 0.1 # minimum improvement to continue
```

### Data Handling

```yaml
data:
  max_file_size: "100MB"
  supported_formats: ["csv", "json", "parquet"]
  auto_sample: true
  sample_size: 1000
```

## Cost Management

### Token Limits

Control LLM usage costs:

```yaml
cost_management:
  max_tokens_per_iteration: 10000
  max_daily_cost: 50.0  # USD
  cheap_model_threshold: 500  # use cheaper models for small tasks
```

### Model Selection

Automatic model routing based on task complexity:

```yaml
model_routing:
  simple_tasks: "gpt-3.5-turbo"
  complex_tasks: "gpt-4"
  code_generation: "gpt-3.5-turbo"
  final_analysis: "gpt-4"
```

## Development Configuration

### Debug Mode

Enable detailed logging and intermediate outputs:

```yaml
debug:
  enabled: true
  log_level: "DEBUG"
  save_intermediate: true
  trace_messages: true
```

### Testing Configuration

Settings for running tests:

```yaml
testing:
  use_mock_llm: true
  fast_execution: true
  skip_expensive_operations: true
  max_test_iterations: 3
```

## Advanced Configuration

### Custom Agents

Add new agent types:

```yaml
agents:
  custom_visualizer:
    class: "CustomVisualizationAgent"
    model: "gpt-4"
    enabled: true
    priority: 5
```

### Integration Settings

External service configuration:

```yaml
integrations:
  jupyter:
    enabled: true
    port: 8888
  
  database:
    provider: "postgresql"
    connection_string: "postgresql://user:pass@localhost/db"
  
  monitoring:
    provider: "wandb"
    project: "dsassist-experiments"
```

## Configuration Validation

DSAssist validates configuration on startup:

- Required fields are present
- Model names are valid
- Resource limits are reasonable
- API keys are available (if not using mock mode)

## Environment-Specific Configs

### Development

```yaml
# config/development.yaml
debug: true
use_mock_responses: true  # or set DSASSIST_USE_MOCK_API=true
max_iterations: 3
fast_execution: true
```

### Production

```yaml
# config/production.yaml
debug: false
use_mock_responses: false  # Real API calls (default behavior)
max_iterations: 10
enable_monitoring: true
```

Load with:
```julia
ENV["DSASSIST_CONFIG"] = "production"
```

## Troubleshooting

### Common Issues

1. **API Key Not Found**: Check `.env` file exists and has correct key. DSAssist automatically loads `.env` files on startup.
2. **Model Not Available**: Verify model name in OpenAI's current list
3. **Timeout Errors**: Increase `timeout` in LLM configuration
4. **Out of Memory**: Reduce `memory_limit` or use smaller datasets
5. **Mock Responses**: If getting unexpected mock data, check that `DSASSIST_USE_MOCK_API` is not set to `true`
6. **Environment Variables**: Use `./scripts/start.sh` which automatically loads `.env` files

### Configuration Testing

Test configuration before running experiments:

```julia
using DSAssist
validate_configuration("config/agents.yaml")
```