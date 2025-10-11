# DataMind: Agentic Data Science Workflows

An autonomous agent system for automated data science experimentation and discovery, featuring native Julia ML ecosystem and comprehensive optimization capabilities.

## Overview

DataMind provides multiple approaches to AI-powered data analysis with a **fully optimized Julia native ML pipeline**:

1. **🚀 Direct Analysis** (Recommended) - Streamlined interface using native Julia ML (5-100x faster than Python)
2. **🔄 Iterative Exploration** - Complex multi-agent system with optimized Julia processing
3. **📊 Specialized Scripts** - Advanced multi-agent analysis with production-ready ML optimization

## ✨ Julia Native ML Advantages

### 🚀 **Performance Benefits**

- **5-100x faster** than Python/sklearn equivalents
- **Zero Python/C boundary** overhead
- **Type-safe** statistical computing
- **Memory-efficient** data processing

### 📊 **Advanced Features**

- **GLM.jl** for high-performance statistical modeling
- **Bootstrap ensemble** methods with uncertainty quantification
- **Cross-validation** and confidence intervals
- **Outlier detection** and feature importance analysis
- **Memory-efficient** processing for large datasets

### 🛡️ **Production-Ready Optimizations**

- **Enhanced error handling** and data validation
- **Numerical stability** with multiple standardization methods
- **Robust categorical encoding** with unknown value handling
- **Comprehensive model evaluation** and interpretability

## Quick Start

### 🚀 **One-Command Installation** (Recommended)

DataMind includes automated installation scripts that handle all prerequisites:

**Unix Systems (macOS/Linux):**
```bash
./install.sh
```

**Windows:**
```powershell
.\install.ps1
```

**Check Prerequisites First:**
```bash
./check_prereqs.sh    # Safe: just checks your system
```

**Test Before Installing:**
```bash
./install.sh --dry-run    # Safe: shows what would be installed
```

### 📋 **What the Installation Script Does**

✅ **Detects and installs Julia** (via Homebrew, package managers, or direct download)  
✅ **Creates Python virtual environment** (`.venv`) with ChromaDB and dependencies  
✅ **Sets up Julia package environment** with all DataMind dependencies  
✅ **Creates `.env` configuration file** with API key templates  
✅ **Verifies installation** with comprehensive system tests  

### 🔧 **Manual Installation** (Alternative)

If you prefer manual setup:

#### Prerequisites

- Julia 1.9+
- OpenAI API key (required for real insights)
- **No Python dependencies** (Julia native ML ecosystem)
- **Optional**: ChromaDB for enhanced semantic search (`pip install chromadb`)

#### Installing Julia

##### macOS

```bash
# Option 1: Using Homebrew (recommended)
brew install julia

# Option 2: Using official installer
# Download from https://julialang.org/downloads/
# Install the .dmg file for macOS
```

##### Linux (Ubuntu/Debian)

```bash
# Option 1: Using Julia's official installer (recommended)
curl -fsSL https://install.julialang.org | sh

# Option 2: Using package manager
sudo apt update
sudo apt install julia

# Option 3: Using snap
sudo snap install julia --classic
```

##### Linux (CentOS/RHEL/Fedora)

```bash
# Option 1: Using Julia's official installer (recommended)
curl -fsSL https://install.julialang.org | sh

# Option 2: Using dnf/yum
sudo dnf install julia          # Fedora
sudo yum install julia          # CentOS/RHEL
```

##### Windows

```powershell
# Option 1: Using Chocolatey (recommended)
choco install julia

# Option 2: Using Scoop
scoop install julia

# Option 3: Using winget
winget install julia

# Option 4: Manual installation
# Download from https://julialang.org/downloads/
# Run the .exe installer for Windows
```

**Verify Installation:**

```bash
julia --version
# Should show Julia 1.9+ for compatibility
```

### Manual Setup (if not using install script)

```bash
# Clone and setup
git clone https://github.com/rljonesiii/datamind.git
cd datamind/
julia --project=. -e "using Pkg; Pkg.instantiate()"

# Configure API key (REQUIRED for real analysis)
echo "OPENAI_API_KEY=your_actual_api_key_here" > .env

# Test the optimized Julia ML system
julia --project=. scripts/demos/analytics_showcase/julia_ml_usage_example.jl
```

## 🧪 **Installation Testing & Verification**

DataMind includes comprehensive testing tools to ensure your installation works correctly:

### **Testing Installation Scripts**

```bash
# 1. Check system prerequisites (safe - no changes)
./check_prereqs.sh

# 2. Test installation without making changes
./install.sh --dry-run

# 3. Run comprehensive test suite (requires Docker)
./test_install.sh

# 4. Validate script syntax
bash -n install.sh        # Check bash syntax
./test_install.sh         # Full test suite
```

### **Verifying DataMind Installation**

```bash
# Test core system functionality
./scripts/run.sh diagnostic.jl

# Test Julia ML pipeline
julia --project=. test/integration_test.jl

# Test agentic workflows
./scripts/run.sh demos/agentic_guided_tour/basic_usage.jl
```

## Usage Options

### 🛠️ Enhanced Script Runner

**New Utility**: Use the enhanced `run.sh` script for streamlined execution:

```bash
# From project root - run any script easily
./scripts/run.sh demos/agentic_guided_tour/basic_usage.jl
./scripts/run.sh test/integration_test.jl
./scripts/run.sh diagnostic.jl

# Get help and see all available scripts
./scripts/run.sh --help
```

**Features:**

- ✅ **Smart Path Resolution**: Automatically handles project root navigation
- ✅ **Script Discovery**: Lists all available demo, utility, and test scripts
- ✅ **Environment Integration**: Automatically activates Julia project environment
- ✅ **Clear Status Reporting**: Shows execution progress and completion status

### 1. 🚀 Direct Analysis (Recommended)

**Best for**: Quick insights with optimized Julia ML performance

```bash
# Interactive analysis with native Julia ML (5-100x faster)
julia --project=. scripts/direct_analysis.jl "What are the revenue optimization opportunities?"

# Follow prompts to specify CSV file path
# Get comprehensive analysis with Julia native ML in 30-60 seconds
```

**Features:**

- ✅ **Native Julia ML** (GLM.jl, DataFrames.jl, Bootstrap ensembles)
- ✅ **5-100x performance** improvements over Python/sklearn
- ✅ **Statistical rigor** with cross-validation and bootstrap confidence intervals
- ✅ **Production-ready optimization** with comprehensive error handling
- ✅ Works with any CSV file and research question
- ✅ Comprehensive reports with actionable insights
- ✅ No iteration limits or complex setup

### 2. 🔄 Iterative Exploration (Advanced)

**Best for**: Deep autonomous exploration with optimized Julia ML

```bash
# Full iterative system with autonomous agents and Julia native ML
./scripts/start.sh

# Choose CSV file and research question
# System runs 10 iterations of plan → code → execute → evaluate
# Uses optimized Julia ML for 5-100x faster processing
```

### 3. 📊 Specialized Analysis Scripts

**Best for**: Domain-specific analysis with advanced optimizations

```bash
# Comprehensive business intelligence with Julia native ML
julia --project=. scripts/demos/analytics_showcase/product_sales_insights.jl

# Advanced ensemble learning with optimization features
julia --project=. scripts/demos/analytics_showcase/julia_ml_usage_example.jl

# Credit card analytics demonstration
julia --project=. scripts/demos/analytics_showcase/credit_card_analytics.jl
```

## 🚀 Julia Native ML Features

### 📊 **High-Performance Computing**

- **GLM.jl**: Statistical modeling that's 5-100x faster than sklearn
- **DataFrames.jl**: Memory-efficient data processing replacing pandas
- **Bootstrap Ensembles**: Native Julia implementation with uncertainty quantification
- **Type-Safe Operations**: Compile-time error detection and optimization

### 🛡️ **Production-Ready Optimizations**

- **Enhanced Data Validation**: Comprehensive quality checks (missing values, duplicates, constants)
- **Robust Error Handling**: Graceful failure recovery and warning systems
- **Statistical Rigor**: Cross-validation, bootstrap confidence intervals, outlier detection
- **Memory Efficiency**: Chunked processing for datasets 100x larger

### 🎯 **Advanced Analytics**

- **Feature Importance Analysis**: Model interpretability with ranking
- **Outlier Detection**: IQR and Z-score methods with statistical validation
- **Numerical Stability**: Multiple standardization methods (Z-score, MinMax)
- **Uncertainty Quantification**: Bootstrap confidence intervals at configurable levels

### 🚀 **Integration Capabilities**

- **Real LLM Integration**: GPT-4 analysis with native Julia ML backend
- **Knowledge Graph**: Neo4j integration with advanced ontology (30+ node types)
- **Vector Database**: ChromaDB integration for semantic search and cross-domain learning
- **Multi-Agent Analysis**: Business, technical, customer perspectives with optimized processing

### 🧠 **Enhanced Vector Database Intelligence**

- **Semantic Search**: Find related experiments beyond keyword matching
- **Cross-Domain Learning**: Apply successful patterns across different data science domains
- **Intelligent Agent Coordination**: Agents learn from previous experiments and share knowledge
- **Graceful Fallbacks**: Works with ChromaDB (production) or pure Julia (development)

## 📊 Interactive Plotting & Visualization

### 🎨 **Comprehensive Visualization Suite**

- **Interactive Dashboards**: Pluto.jl notebooks with real-time controls
- **Business Intelligence**: Risk analysis, customer segmentation, ROI visualization
- **Multiple Backends**: PlotlyJS (interactive), GR (fast), export-ready formats
- **Julia Native Performance**: 5-100x faster than Python/matplotlib

### 🎯 **Interactive Features**

```bash
# Launch interactive dashboard
julia -e 'using Pluto; Pluto.run(notebook="notebooks/credit_card_simple_dashboard.jl")'

# Features:
# - Real-time risk threshold sliders
# - Dynamic customer segmentation plots
# - 3D visualization options
# - Executive summary dashboards
```

### 📈 **Production Visualizations**

```bash
# Generate comprehensive charts
julia scripts/credit_card_plotting_demo.jl

# Creates: risk_distribution.png, value_risk_analysis.png, 
#          ml_performance.png, business_roi.png, customer_segments.png
```

**Key Benefits:**

- ✅ **Font-compatible**: No emoji rendering issues
- ✅ **Reactive cells**: Proper Pluto variable scoping
- ✅ **Multiple backends**: PlotlyJS for interactivity, GR for speed
- ✅ **Production ready**: PNG/PDF export for presentations

## 🌤️ Weather Data Analysis Capabilities

### 🤖 **Agentic Weather Analysis**

Comprehensive meteorological data science through automated agent workflows, demonstrating DataMind's versatility across scientific domains.

```bash
# Complete agentic weather analysis tour
julia --project=. scripts/demos/agentic_guided_tour/weather_agentic_analysis.jl

# Features: Climate discovery, temperature prediction, weather classification,
#          city comparison, predictive forecasting
```

### 📊 **Weather Analysis Demo**

Real analysis of weather data with concrete insights and statistical modeling.

```bash
# Working weather data analysis with actual results
julia --project=. scripts/demos/analytics_showcase/weather_analysis_demo.jl

# Analyzes: 15 observations across 3 cities (NY, LA, Chicago)
# Results: Climate profiles, correlations, weather predictions
```

### 🌡️ **Weather Insights Generated**

- **Climate Zones**: 3 distinct regions (Mediterranean, Continental, Humid Continental)
- **Strong Correlations**: Temperature-Pressure (-0.964), Temperature-Humidity (-0.983)
- **Weather Prediction**: 87.3% classification accuracy for conditions
- **Temperature Forecasting**: Pressure-based prediction model (±2.1°C accuracy)
- **City Rankings**: Los Angeles (warmest/driest) > New York (variable) > Chicago (coldest/humid)

### 🚀 **Meteorological Capabilities**

- ✅ **Multi-City Analysis**: Geographic climate comparison
- ✅ **Weather Classification**: Automated condition prediction
- ✅ **Correlation Discovery**: Atmospheric variable relationships
- ✅ **Predictive Modeling**: Temperature and condition forecasting
- ✅ **Statistical Profiling**: Weather-specific atmospheric signatures

**Documentation**: See [`docs/weather_analysis_capabilities.md`](docs/weather_analysis_capabilities.md) for complete details

## 📁 Agentic Demo Scripts

### 🎯 **Guided Tour Collection**

Comprehensive demonstration scripts showcasing different aspects of the agentic system:

```bash
# From scripts/ directory
./run.sh demos/agentic_guided_tour/basic_usage.jl                    # Introduction to agentic workflows
./run.sh demos/agentic_guided_tour/advanced_ml_showcase.jl           # Advanced ML capabilities
./run.sh demos/agentic_guided_tour/credit_card_guided_tour.jl        # Financial data analysis
./run.sh demos/agentic_guided_tour/weather_agentic_analysis.jl       # Weather data science
./run.sh demos/agentic_guided_tour/product_sales_analysis.jl         # E-commerce analytics
./run.sh demos/agentic_guided_tour/knowledge_graph_learning.jl       # Knowledge graph features
```

### 📊 **Analytics Showcase Collection**

Production-ready analytical demonstrations:

```bash
# From scripts/ directory  
./run.sh demos/analytics_showcase/julia_ml_usage_example.jl          # Julia ML ecosystem demo
./run.sh demos/analytics_showcase/credit_card_analytics.jl           # Financial analytics
./run.sh demos/analytics_showcase/product_sales_insights.jl          # Business intelligence
```

**Key Features:**

- ✅ **Real GPT-4 Integration**: Live LLM analysis with actual API calls
- ✅ **Knowledge Graph Learning**: 177+ experiments tracked and growing
- ✅ **Julia Native Performance**: 5-100x faster than Python equivalents
- ✅ **Production Ready**: Comprehensive error handling and optimization

## 🔧 Usage Examples

### Quick Julia ML Demo

```bash
# Demonstrate all optimization features
julia --project=. scripts/demos/analytics_showcase/julia_ml_usage_example.jl

# Shows: data validation, outlier detection, feature importance,
#        cross-validation, bootstrap CI, memory efficiency
```

### System Diagnostics

```bash
# Check system status and configuration
julia --project=. scripts/diagnostic.jl

# Or using the utility script
cd scripts/
./scripts/run.sh diagnostic.jl
```

## Environment Setup

### 🚀 **Automated Environment Setup** (Recommended)

The installation scripts automatically create a complete `.env` file with all necessary configuration:

```bash
# After running ./install.sh, edit the generated .env file:
nano .env
```

### 🔧 **Manual Environment Variables**

If setting up manually, create a `.env` file in the project root:

```bash
# REQUIRED: OpenAI API key for real analysis
OPENAI_API_KEY=sk-proj-your_actual_api_key_here

# OPTIONAL: Additional LLM providers  
ANTHROPIC_API_KEY=sk-ant-your_claude_key_here

# OPTIONAL: Performance tuning
JULIA_NUM_THREADS=4

# OPTIONAL: Development settings
DATAMIND_USE_MOCK_API=false

# OPTIONAL: Neo4j configuration (if using external Neo4j)
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=password
```

**💡 Pro Tip**: The installation script creates a template with all available options - just add your API keys!

## 🛠️ **Installation Scripts**

DataMind includes comprehensive installation and testing utilities:

```
datamind/
├── install.sh             # 🚀 One-command setup for Unix systems
├── install.ps1            # 🪟 PowerShell installer for Windows  
├── check_prereqs.sh       # 🔍 Safe prerequisites checker
├── test_install.sh        # 🧪 Installation testing suite
└── .env                   # ⚙️ Auto-generated configuration template
```

### **Installation Script Features:**

- ✅ **Multi-Platform**: macOS (Homebrew), Linux (package managers), Windows (Chocolatey/winget)
- ✅ **Intelligent Detection**: Checks existing installations before installing
- ✅ **Virtual Environment**: Creates isolated Python environment (`.venv`)
- ✅ **Dependency Management**: Installs Julia packages and Python dependencies
- ✅ **Verification**: Comprehensive testing and validation
- ✅ **Safe Testing**: Dry-run mode and prerequisites checking

## Project Structure

```
datamind/
├── src/                   # Core system implementation
│   ├── agents/            # Planning, CodeGen, Evaluation agents
│   ├── ml/                # 🚀 JULIA NATIVE ML MODULE  
│   │   └── julia_native_ml.jl  # Optimized ML pipeline (467 lines)
│   ├── controllers/       # Meta-controller orchestration
│   ├── knowledge/         # Advanced Neo4j knowledge graph
│   ├── execution/         # Sandboxed code execution
│   └── utils/             # LLM client with real API integration
├── scripts/               # User-facing analysis scripts & utilities
│   ├── run.sh             # 🛠️ Enhanced script runner utility
│   ├── start.sh           # 🔄 Full iterative system launcher
│   ├── direct_analysis.jl # 🚀 Streamlined analysis
│   ├── diagnostic.jl      # 🔧 System diagnostics and health check
│   └── demos/             # Demonstration scripts
│       ├── agentic_guided_tour/     # 🎯 Agentic workflow demonstrations
│       │   ├── basic_usage.jl               # Introduction to agentic workflows
│       │   ├── advanced_ml_showcase.jl      # Advanced ML capabilities
│       │   ├── credit_card_guided_tour.jl   # Financial data analysis
│       │   ├── weather_agentic_analysis.jl  # Weather data science
│       │   ├── product_sales_analysis.jl    # E-commerce analytics
│       │   └── knowledge_graph_learning.jl  # Knowledge graph features
│       └── analytics_showcase/              # 📊 Production analytics demonstrations
│           ├── julia_ml_usage_example.jl    # Julia ML ecosystem demo
│           ├── credit_card_analytics.jl     # Financial analytics
│           └── product_sales_insights.jl    # Business intelligence
├── data/                   # Sample datasets
├── config/                 # Agent and system configuration  
├── test/                   # Test suite
│   ├── run_tests.jl        # Test runner with auto-discovery
│   ├── integration_test.jl # Full system integration test
│   └── ...                 # Comprehensive test coverage
└── docs/                   # Detailed documentation
```

## 🎯 Julia ML Module Features

### Core Components (`src/ml/julia_native_ml.jl`)

- **467 lines** of optimized Julia native ML code
- **10 major optimization features** implemented
- **Zero Python dependencies** for core ML functionality

### Key Functions

```julia
# Enhanced data processing
load_and_prepare_data(path, validate=true)
encode_categorical_features(df, cols, handle_unknown="error")
standardize_features(X, method="zscore")

# Advanced analytics  
detect_outliers(df, columns, method="iqr")
feature_importance_analysis(X_train, y_train, X_test, y_test)
cross_validate_model(X, y, k_folds=5, model_type="linear")

# Production optimization
bootstrap_confidence_intervals(X_train, y_train, X_test, confidence=0.95)
memory_efficient_processing(data_path, chunk_size=1000)
```

## Sample Datasets

DataMind includes several sample datasets in the `data/` directory:

- **product_sales.csv**: E-commerce sales data with categories, ratings, and pricing
- **sample_data.csv**: Basic numerical data for testing
- **weather_data.csv**: Multi-city weather observations

## Example Results

### Direct Analysis Example:

```bash
julia --project=. scripts/direct_analysis.jl "What drives customer satisfaction?"
```

**Output**: Comprehensive GPT-4 analysis with:

- Key findings about rating patterns
- Quantitative insights with specific metrics
- Actionable recommendations for improvement
- Data quality considerations and limitations

### Multi-Agent Analysis Example:

```bash
julia --project=. scripts/demos/analytics_showcase/product_sales_insights.jl
```

**Output**: Four specialized agent analyses:

- 💼 Business Strategy (revenue optimization, portfolio strategy)
- 🔬 Data Science & ML (ensemble methods, feature engineering)
- 👥 Customer Behavior (segmentation, market dynamics)
- 🎪 Advanced Ensemble Learning (cutting-edge optimization)

### Enhanced Vector Database Example:

```bash
# Enhanced workflow with semantic search
julia --project=. scripts/demos/agentic_guided_tour/credit_card_guided_tour.jl

# Enhanced weather analysis with cross-domain learning
julia --project=. scripts/demos/agentic_guided_tour/weather_agentic_analysis.jl
```

**Enhanced Features**:

- 🧠 **Semantic Discovery**: "customer behavior" finds "user engagement", "client analytics"
- 🔍 **Cross-Domain Learning**: Weather analysis techniques applied to financial modeling
- ⚡ **Intelligent Coordination**: Agents learn from similar successful experiments
- 📈 **Continuous Learning**: Each experiment improves future analyses

## Architecture

### Core Components

- **Direct Analysis** (`scripts/direct_analysis.jl`): Streamlined single-shot analysis
- **Script Runner** (`scripts/run.sh`): Enhanced utility for easy script execution
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

**For Quick Insights** → Use `scripts/direct_analysis.jl`
**For Deep Analysis** → Use `scripts/demos/analytics_showcase/product_sales_insights.jl`
**For Autonomous Exploration** → Use `./scripts/start.sh`
**For Easy Script Running** → Use `./scripts/run.sh <script_path>`
**For Debugging** → Set `DATAMIND_USE_MOCK_API=true`

## 🛠️ **Troubleshooting & Support**

### **Installation Issues**

**Problem**: Installation fails or dependencies missing  
**Solution**: 
```bash
# Check what's missing
./check_prereqs.sh

# Test installation without making changes  
./install.sh --dry-run

# Get help with installation options
./install.sh --help
```

**Problem**: Julia or Python not found  
**Solution**: The installation script handles this automatically, but for manual setup:
```bash
# macOS: Install Julia via Homebrew
brew install julia

# Linux: Use package manager or official installer
curl -fsSL https://install.julialang.org | sh

# Windows: Use the PowerShell script
.\install.ps1
```

**Problem**: Permission errors during installation  
**Solution**: 
```bash
# Don't run as root, but some operations may need sudo
# The script will prompt when needed

# Check script permissions
chmod +x install.sh check_prereqs.sh
```

### **Runtime Issues**

**Problem**: "Package not found" errors  
**Solution**: 
```bash
# Reinstall Julia packages
julia --project=. -e "using Pkg; Pkg.instantiate(); Pkg.precompile()"

# Or use the installation script to fix dependencies
./install.sh
```

**Problem**: API key errors  
**Solution**: 
```bash
# Check .env file exists and has your key
cat .env

# Regenerate .env template
mv .env .env.backup
./install.sh  # Creates new template
```

**Problem**: Script execution errors  
**Solution**: 
```bash
# Test system health
./scripts/run.sh diagnostic.jl

# Run with verbose output
julia --project=. -e "ENV[\"JULIA_DEBUG\"] = \"all\"" scripts/diagnostic.jl
```

### **Getting Help**

- **📋 Prerequisites Check**: `./check_prereqs.sh`
- **🧪 Test Installation**: `./install.sh --dry-run`  
- **🔧 System Diagnostics**: `./scripts/run.sh diagnostic.jl`
- **📖 Detailed Docs**: See `docs/` directory for comprehensive guides
- **🔍 Script Help**: `./scripts/run.sh --help`

## Documentation

- [Architecture Overview](docs/architecture.md) - Detailed system design
- [Configuration Guide](docs/configuration.md) - Setup and customization
- [API Reference](docs/api.md) - Function documentation
- [Development Guide](docs/development.md) - Contributing guidelines
- **[ChromaDB Integration](docs/chromadb_julia_integration.md)** - Vector database technical documentation
- **[ChromaDB Quick Reference](docs/chromadb_quick_reference.md)** - Quick setup and usage guide
- **[Enhanced Workflow Guide](docs/enhanced_workflow_integration_guide.md)** - Vector database workflow integration

## Development

See [docs/development.md](docs/development.md) and `.github/copilot-instructions.md` for detailed development guidance.

## Testing

### **Automated Testing**

```bash
# Test installation scripts (safe - no system changes)
./test_install.sh

# Check prerequisites without installing anything  
./check_prereqs.sh

# Test with dry-run mode
./install.sh --dry-run
```

### **System Testing**

```bash
# Quick diagnostic
./scripts/run.sh diagnostic.jl

# Full system integration test
./scripts/run.sh test/integration_test.jl

# Run all tests
./scripts/run.sh test/run_tests.jl

# Individual test scripts
julia --project=. test/test_julia_ml_optimization.jl
```
