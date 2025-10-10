#!/bin/bash

# DSAssist Startup Script
# This script sets up the environment and starts the DSAssist system

set -e  # Exit on any error

echo "🧪 Starting DSAssist: Agentic Data Science Workflows"
echo "=================================================="

# Get the script directory and project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Load environment variables from .env file
if [ -f "$PROJECT_ROOT/.env" ]; then
    echo "🔑 Loading environment variables from .env..."
    export $(grep -v '^#' "$PROJECT_ROOT/.env" | xargs)
    echo "✅ Environment variables loaded"
else
    echo "⚠️  No .env file found, continuing without custom environment"
fi

# Check if Julia is installed
if ! command -v julia &> /dev/null; then
    echo "❌ Julia is not installed or not in PATH"
    echo "Please install Julia 1.9+ from https://julialang.org/"
    exit 1
fi

# Check Julia version
JULIA_VERSION=$(julia --version | grep -o '[0-9]\+\.[0-9]\+')
echo "📋 Detected Julia version: $JULIA_VERSION"

# Navigate to project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

echo "📁 Project directory: $(pwd)"

# Check if Project.toml exists
if [ ! -f "Project.toml" ]; then
    echo "❌ Project.toml not found. Are you in the DSAssist directory?"
    exit 1
fi

# Install/update dependencies
echo "📦 Installing Julia dependencies..."
julia --project=. -e "using Pkg; Pkg.instantiate()"

# Check for configuration files
if [ ! -f "config/agents.yaml" ]; then
    echo "⚠️  Warning: config/agents.yaml not found"
fi

# Check for environment variables
if [ ! -f ".env" ]; then
    echo "⚠️  Warning: .env file not found. Using mock LLM responses."
    echo "To use real OpenAI API, create .env with: OPENAI_API_KEY=your_key"
fi

# Run system diagnostics
echo "🔍 Running system diagnostics..."
julia --project=. scripts/diagnostic.jl

if [ $? -eq 0 ]; then
    echo "✅ System check passed"
    echo "🚀 Starting DSAssist..."
    julia --project=. src/main.jl
else
    echo "❌ System check failed. Please resolve issues before starting."
    exit 1
fi