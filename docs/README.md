# DataMind Documentation

## Table of Contents

- **🏗️ Architecture**: 
  - [System Architecture](architecture.md) - Core design and agent communication patterns
  - [Architecture Diagrams](architecture_diagrams.md) - Comprehensive Mermaid diagrams and visual system overview
- **📊 Data & Analytics**:
  - [Plotting Capabilities](plotting_capabilities.md) - Interactive plotting with Pluto.jl and visualization features
  - [Weather Analysis Capabilities](weather_analysis_capabilities.md) - Comprehensive meteorological analysis guide
  - [Weather Analysis Usage Guide](weather_analysis_usage_guide.md) - Quick start guide for weather scripts
- **🧠 Knowledge Management**:
  - [Knowledge Graph Summary](knowledge_graph_summary.md) - Quick overview of knowledge graph capabilities
  - [Knowledge Graph Usage](knowledge_graph_usage.md) - Comprehensive guide to learning patterns and ontology
  - [Knowledge Graph Ontology](knowledge_graph_ontology.md) - Detailed ontology structure and relationships
  - [Neo4j Integration](neo4j_integration.md) - Graph database setup and configuration
- **💾 Vector Database**:
  - [ChromaDB Quick Reference](chromadb_quick_reference.md) - Vector database setup and usage
- **⚙️ Configuration & Development**:
  - [Configuration Guide](configuration.md) - Agent setup, LLMs, and environment configuration
  - [Development Guides](development/) - Contributing, extending, and advanced development topics

## Quick Start

For immediate usage, see the main [README.md](../README.md) in the project root.

### 🚀 **Get Started in 3 Steps:**
1. **Setup**: `julia --project=. -e "using Pkg; Pkg.instantiate()"`
2. **Configure**: Add `OPENAI_API_KEY=your_key` to `.env` file
3. **Run**: `cd scripts/ && ./run.sh demos/agentic_guided_tour/basic_usage.jl`

## System Overview

### 🤖 **DataMind Architecture**
DataMind implements an advanced multi-agent system for autonomous data science experimentation:

- **🎯 Meta-Controller**: Orchestrates experiment lifecycle and manages agent coordination
- **🧠 Planning Agent**: Decomposes research questions into minimal actionable subtasks
- **💻 Code Generation Agent**: Creates executable Julia code with context awareness
- **⚡ Execution Environment**: Sandboxed Julia native processing for maximum performance
- **📊 Evaluation Agent**: Analyzes results and determines success/failure/retry decisions
- **🤔 Reflection Agent**: Updates knowledge graph and triggers next planning cycles

### 🚀 **Core Capabilities**
- **Julia Native ML**: 5-100x faster than Python/sklearn equivalents with zero overhead
- **Real LLM Integration**: GPT-4 and Claude-4 powered analysis with actual API calls (177+ experiments tracked)
- **Knowledge Graph Learning**: Neo4j backend with advanced ontology and pattern recognition. Can be replaced easily with MemGraph, among others.
- **Vector Database**: ChromaDB integration for semantic search and cross-domain learning. Can be replaced [SemaDbAPI.jl](https://github.com/imohag9/SemaDbAPI.jl) for better performance and enterprise-grade scaling in the Julia ecosystem.
- **Production Ready**: Comprehensive error handling, data validation, and optimization

### 🔄 **Workflow Patterns**

#### 1. **Enhanced Script Runner** (Recommended)
```bash
cd scripts/
./run.sh demos/agentic_guided_tour/basic_usage.jl           # Introduction workflow
./run.sh demos/agentic_guided_tour/credit_card_guided_tour.jl # Financial analysis
./run.sh demos/analytics_showcase/julia_ml_usage_example.jl   # ML demonstration
```

#### 2. **Direct Analysis**
```bash
julia --project=. scripts/direct_analysis.jl "What drives customer satisfaction?"
```

#### 3. **Autonomous Exploration**
```bash
./scripts/start.sh   # Full iterative system with multi-agent collaboration
```

### ⚙️ **Configuration**
The system is configured through YAML files in the `config/` directory and environment variables:

- **`config/agents.yaml`**: Agent behavior, LLM settings, and workflow parameters
- **`.env` file**: API keys (`OPENAI_API_KEY=your_key ANTHROPIC_API_KEY=your_key`) and environment configuration
- **`Project.toml`**: Julia dependencies and package management

### 📁 **Project Structure**
```
datamind/
├── scripts/                   # 🛠️ Enhanced script runner and demonstration scripts
│   ├── run.sh                 # Smart script execution utility
│   └── demos/                 # Comprehensive agentic workflow demonstrations
├── src/                       # 🏗️ Core system implementation
│   ├── agents/                # Multi-agent system components
│   ├── ml/julia_native_ml.jl  # 🚀 Optimized Julia ML pipeline (467 lines)
│   └── knowledge/             # Knowledge graph and vector database integration
├── data/                      # 📊 Sample datasets (credit card, e-commerce, weather, HR)
└── docs/                      # 📚 Comprehensive documentation
```

### 🎯 **Key Features**
- **✅ Real Agentic Workflows**: Live GPT/Claude-4 agents with plan → code → execute → evaluate → reflect cycles
- **✅ Julia Native Performance**: 5-100x faster ML processing than Python equivalents
- **✅ Knowledge Graph Learning**: 177+ experiments tracked with pattern recognition
- **✅ Vector Database Intelligence**: Semantic search and cross-domain learning
- **✅ Production Optimization**: Comprehensive error handling and data validation

See [Configuration Guide](configuration.md) for detailed setup instructions.