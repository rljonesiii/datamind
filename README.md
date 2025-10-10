# DSAssist: Agentic Data Science Workflows

An autonomous agent system for automated data science experimentation and discovery, featuring real LLM-powered insights and comprehensive analysis capabilities.

## Overview

DSAssist provides multiple approaches to AI-powered data analysis:

1. **🚀 Direct Analysis** (Recommended) - Streamlined interface for immediate insights using GPT-4
2. **🔄 Iterative Exploration** - Complex multi-agent system for autonomous experimentation  
3. **📊 Specialized Scripts** - Advanced multi-agent analysis for specific domains

## Quick Start

### Prerequisites
- Julia 1.9+
- OpenAI API key (required for real insights)
- Python 3.8+ (optional, for extended integrations)

### Installation

```bash
# Clone and setup
git clone <repository>
cd dsassist
julia --project=. -e "using Pkg; Pkg.instantiate()"

# Configure API key (REQUIRED for real analysis)
echo "OPENAI_API_KEY=your_actual_api_key_here" > .env

# Test the system
./scripts/start.sh
```

## Usage Options

### 1. 🚀 Direct Analysis (Recommended)

**Best for**: Quick insights, any research question, any CSV data

```bash
# Interactive analysis with any research question
julia --project=. scripts/dsassist_direct.jl "What are the revenue optimization opportunities?"

# Follow prompts to specify CSV file path
# Get comprehensive GPT-4 analysis in 30-60 seconds
```

**Features:**
- ✅ Real GPT-4 analysis (no mock responses)
- ✅ Works with any CSV file and research question  
- ✅ Comprehensive reports with actionable insights
- ✅ No iteration limits or complex setup

### 2. 🔄 Iterative Exploration (Advanced)

**Best for**: Deep autonomous exploration, complex hypotheses

```bash
# Full iterative system with autonomous agents
./scripts/start.sh

# Choose CSV file and research question
# System runs 10 iterations of plan → code → execute → evaluate
```

### 3. 📊 Specialized Analysis Scripts

**Best for**: Domain-specific multi-agent analysis

```bash
# Comprehensive business intelligence analysis
julia --project=. scripts/product_sales_insights.jl

# Advanced ensemble learning analysis  
julia --project=. scripts/comprehensive_product_insights.jl
```
## Key Features

### 🎯 Real LLM Integration
- **GPT-4 Analysis**: Real API calls provide dynamic, contextual insights
- **No Mock Responses**: Environment variable automatically loads API keys
- **Intelligent Agents**: Specialized agents for business strategy, ML, and customer behavior

### 📊 Advanced Analytics
- **Ensemble Learning**: Stacking, bagging, boosting, and Bayesian methods
- **Knowledge Graph**: Neo4j integration with advanced ontology (30+ node types)
- **Multi-Agent Analysis**: Business, technical, customer, and ensemble perspectives

### 🚀 Streamlined Interface  
- **Direct Analysis**: Get insights in 30-60 seconds for any research question
- **Automatic Data Summary**: Comprehensive dataset analysis for LLM context
- **CSV Compatibility**: Works with any structured data file

## Environment Setup

### Required Environment Variables

Create a `.env` file in the project root:

```bash
# REQUIRED: OpenAI API key for real analysis
OPENAI_API_KEY=sk-proj-your_actual_api_key_here

# OPTIONAL: Additional LLM providers
ANTHROPIC_API_KEY=sk-ant-your_claude_key_here

# OPTIONAL: Execution settings
JULIA_NUM_THREADS=4
```

**Important**: The system now defaults to real API calls. Mock responses only activate when:
- No API key is provided, OR
- `DSASSIST_USE_MOCK_API=true` is explicitly set for debugging

## Project Structure

```
dsassist/
├── src/                    # Core system implementation
│   ├── agents/            # Planning, CodeGen, Evaluation agents  
│   ├── controllers/       # Meta-controller orchestration
│   ├── knowledge/         # Advanced Neo4j knowledge graph
│   ├── execution/         # Sandboxed code execution (fixed)
│   └── utils/            # LLM client with real API integration
├── scripts/               # User-facing analysis scripts
│   ├── dsassist_direct.jl      # 🚀 Streamlined analysis (recommended)
│   ├── product_sales_insights.jl # 📊 Multi-agent business analysis  
│   └── start.sh               # 🔄 Full iterative system launcher
├── data/                  # Sample datasets
├── config/               # Agent and system configuration  
└── docs/                 # Detailed documentation
```

## Sample Datasets

DSAssist includes several sample datasets in the `data/` directory:
- **product_sales.csv**: E-commerce sales data with categories, ratings, and pricing
- **sample_data.csv**: Basic numerical data for testing
- **weather_data.csv**: Multi-city weather observations

## Example Results

### Direct Analysis Example:
```bash
julia --project=. scripts/dsassist_direct.jl "What drives customer satisfaction?"
```

**Output**: Comprehensive GPT-4 analysis with:
- Key findings about rating patterns
- Quantitative insights with specific metrics  
- Actionable recommendations for improvement
- Data quality considerations and limitations

### Multi-Agent Analysis Example:
```bash  
julia --project=. scripts/product_sales_insights.jl
```

**Output**: Four specialized agent analyses:
- 💼 Business Strategy (revenue optimization, portfolio strategy)
- 🔬 Data Science & ML (ensemble methods, feature engineering) 
- 👥 Customer Behavior (segmentation, market dynamics)
- 🎪 Advanced Ensemble Learning (cutting-edge optimization)

## Architecture

### Core Components
- **Direct Analysis** (`scripts/dsassist_direct.jl`): Streamlined single-shot analysis
- **Meta-Controller** (`src/controllers/`): Orchestrates iterative experiment cycles  
- **Specialized Agents** (`src/agents/`): Planning, CodeGen, and Evaluation
- **Knowledge Graph** (`src/knowledge/`): Advanced Neo4j ontology with ensemble intelligence
- **LLM Client** (`src/utils/llm_client.jl`): Real API integration with fallback handling

### Fixed Issues
- ✅ **Real API Calls**: Default behavior, no environment variable required
- ✅ **Environment Loading**: Startup script automatically loads `.env` files
- ✅ **Execution Sandbox**: Fixed variable scoping issues in code execution
- ✅ **Dependency Management**: Complete package requirements in Project.toml

## Configuration

### Agent Configuration (`config/agents.yaml`)
```yaml
agents:
  planning:
    model: "gpt-4"
    temperature: 0.3
    max_tokens: 1000
    
experiment:
  max_iterations: 10
  
llm_routing:
  cost_aware: true
  budget_limit: 100.0
```

### Usage Modes

**For Quick Insights** → Use `scripts/dsassist_direct.jl`
**For Deep Analysis** → Use `scripts/product_sales_insights.jl`  
**For Autonomous Exploration** → Use `./scripts/start.sh`
**For Debugging** → Set `DSASSIST_USE_MOCK_API=true`

## Documentation

- [Architecture Overview](docs/architecture.md) - Detailed system design
- [Configuration Guide](docs/configuration.md) - Setup and customization
- [API Reference](docs/api.md) - Function documentation
- [Development Guide](docs/development.md) - Contributing guidelines

## Development

See [docs/development.md](docs/development.md) and `.github/copilot-instructions.md` for detailed development guidance.

## Testing

```bash
# Quick diagnostic
julia scripts/diagnostic.jl

# Full system test
julia --project=. scripts/full_test.jl

# Unit tests
julia --project=. test/runtests.jl
```