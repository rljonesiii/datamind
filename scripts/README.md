# Scripts Directory

This directory contains analysis scripts and utility tools for DataMind.

## Recommended Entry Points

🚀 **New Users**: Start with `direct_analysis.jl` - it provides guided DataMind intelligence for any research question

🧪 **Explore Features**: Try demos in `demos/agentic_guided_tour/` to experience different DataMind capabilities

### `product_sales_insights.jl`
- **Purpose**: Advanced multi-agent analysis with 4 specialized agents
- **Usage**: `julia --project=. scripts/product_sales_insights.jl`
- **Features**:
  - Business Strategy Analysis (revenue optimization, portfolio strategy)
  - Data Science & ML Insights (ensemble methods, feature engineering)
  - Customer Behavior Analysis (segmentation, market dynamics)
  - Advanced Ensemble Learning (cutting-edge optimization techniques)
  - Synthesis and Integration of all perspectives

### `comprehensive_product_insights.jl`
- **Purpose**: LLM-powered business intelligence generation
- **Usage**: `julia --project=. scripts/comprehensive_product_insights.jl`
- **Features**: Strategic insights, customer behavior patterns, ML recommendations

## 🔧 System Scripts

### `start.sh`
- **Purpose**: Launch full iterative DSAssist system
- **Usage**: `./scripts/start.sh`
- **Features**:
  - Automatically loads environment variables from `.env`
  - Installs dependencies and runs diagnostics
  - Launches interactive experiment system
  - Real API calls by default (no environment variable needed)

### `diagnostic.jl`
- **Purpose**: Quick system health check
- **Usage**: `julia --project=. scripts/diagnostic.jl`
- **Description**: Tests basic imports, file structure, and module loading

## 📊 Usage Examples

### Quick Analysis (Recommended)
```bash
# Interactive analysis - most common use case
julia --project=. scripts/direct_analysis.jl "What are the revenue optimization opportunities?"

# Follow prompts to specify CSV file
# Get comprehensive GPT-4 analysis in under 60 seconds
```

### Advanced Multi-Agent Analysis
```bash
# Comprehensive business intelligence with 4 specialized agents
julia --project=. scripts/product_sales_insights.jl

# Generates:
# - Business strategy recommendations
# - Technical ML insights  
# - Customer behavior analysis
# - Ensemble learning optimization
# - Integrated strategic framework
```

### Full Iterative System
```bash
# Launch autonomous experimentation system
./scripts/start.sh

# Interactive prompts for:
# - CSV file selection
# - Research question input
# - 10 iterations of autonomous exploration
```

## 🛠️ Development & Testing

### System Health Check
```bash
# Quick diagnostic
julia --project=. scripts/diagnostic.jl
```

### Environment Variables
The startup script automatically loads `.env` files. Create one with:
```bash
echo "OPENAI_API_KEY=your_api_key_here" > .env
```

### API Behavior
- **Default**: Real GPT-4 API calls
- **Debug Mode**: Set `DATAMIND_USE_MOCK_API=true` for testing without API costs
- **No API Key**: Automatically falls back to mock responses with warnings

## 🎯 Script Selection Guide

| Use Case | Script | Best For |
|----------|--------|----------|
| **Quick insights on any data** | `direct_analysis.jl` | Any research question, any CSV |
| **Deep business analysis** | `product_sales_insights.jl` | Product/sales data, strategic decisions |
| **Autonomous exploration** | `start.sh` | Complex hypotheses, iterative discovery |
| **System testing** | `diagnostic.jl` | Development, troubleshooting |

## 🔧 Recent Fixes

- ✅ **Real API calls by default** - No environment variable setup required
- ✅ **Environment loading** - Startup script loads `.env` automatically  
- ✅ **Execution sandbox** - Fixed variable scoping issues
- ✅ **Streamlined interface** - Direct analysis bypasses iteration complexity
julia scripts/diagnostic.jl

# Full system test
julia --project=. scripts/full_test.jl

# Production start
chmod +x scripts/start.sh
./scripts/start.sh
```

## Adding New Scripts

- Place utility scripts here
- Use descriptive names
- Include purpose and usage in this README
- Make shell scripts executable with `chmod +x`