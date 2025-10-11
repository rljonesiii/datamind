#!/bin/bash

# DataMind Julia Script Runner
# Usage: ./run.sh <script_path_from_project_root>
# Run from: scripts/ directory
# Example: ./run.sh demos/agentic_guided_tour/basic_usage.jl
# Note: Script paths are relative to project root, not scripts/ directory

# Change to project root directory (parent of scripts/)
cd "$(dirname "$0")/.."

# Check if a script path was provided or if help is requested
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "🚀 DataMind Julia Script Runner"
    echo "================================"
    echo "📍 Run from: scripts/ directory"
    echo ""
    echo "Usage: ./run.sh <script_path>"
    echo ""
    echo "Examples (from scripts/ directory):"
    echo "  ./run.sh demos/agentic_guided_tour/basic_usage.jl"
    echo "  ./run.sh demos/agentic_guided_tour/credit_card_guided_tour.jl"
    echo "  ./run.sh demos/agentic_guided_tour/product_sales_analysis.jl"
    echo "  ./run.sh demos/agentic_guided_tour/weather_agentic_analysis.jl"
    echo "  ./run.sh demos/analytics_showcase/credit_card_analytics.jl"
    echo "  ./run.sh test/integration_test.jl"
    echo "  ./run.sh test/run_tests.jl"
    echo "  ./run.sh scripts/diagnostic.jl"
    echo ""
    echo "Available demo scripts:"
    echo "  📁 scripts/demos/agentic_guided_tour/"
    find scripts/demos/agentic_guided_tour/ -name "*.jl" 2>/dev/null | head -10 | sed 's/^/    /'
    echo "  📁 scripts/demos/analytics_showcase/"
    find scripts/demos/analytics_showcase/ -name "*.jl" 2>/dev/null | head -5 | sed 's/^/    /'
    echo "  📁 scripts/ (utility scripts):"
    find scripts/ -maxdepth 1 -name "*.jl" 2>/dev/null | sed 's/^/    /'
    echo "  📁 test/ (test scripts):"
    find test/ -name "*.jl" 2>/dev/null | head -5 | sed 's/^/    /'
    echo ""
    exit 1
fi

# Get the script path
SCRIPT_PATH="$1"

# Handle relative paths - if path doesn't start with scripts/, test/, or src/, assume it's in scripts/
if [[ ! "$SCRIPT_PATH" =~ ^(scripts/|test/|src/|\.\./|\.|/) ]]; then
    SCRIPT_PATH="scripts/$SCRIPT_PATH"
fi

# Check if the script file exists
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "❌ Error: Script file '$SCRIPT_PATH' not found"
    echo ""
    echo "💡 Available scripts:"
    echo "  📁 scripts/demos/"
    find scripts/demos/ -name "*.jl" 2>/dev/null | head -10 | sed 's/^/    /'
    echo "  📁 scripts/ (utility scripts):"
    find scripts/ -maxdepth 1 -name "*.jl" 2>/dev/null | sed 's/^/    /'
    echo "  📁 test/"
    find test/ -name "*.jl" 2>/dev/null | head -5 | sed 's/^/    /'
    exit 1
fi

# Display what we're running
echo "🚀 Running DataMind Julia Script"
echo "================================"
echo "📄 Script: $SCRIPT_PATH"
echo "📦 Project: $(pwd)"
echo ""

# Run the Julia script with the project environment
julia --project=. "$SCRIPT_PATH"

# Capture the exit code
EXIT_CODE=$?

echo ""
echo "================================"
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Script completed successfully"
else
    echo "❌ Script failed with exit code: $EXIT_CODE"
fi
echo "🚀 DataMind execution finished"