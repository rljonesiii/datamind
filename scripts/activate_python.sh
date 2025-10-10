#!/bin/bash

# DSAssist Python Environment Activation Script
# This script activates the Python virtual environment for DSAssist

echo "🐍 Activating DSAssist Python Virtual Environment"
echo "================================================="

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Check if virtual environment exists
if [ ! -d "$PROJECT_DIR/venv" ]; then
    echo "❌ Virtual environment not found at $PROJECT_DIR/venv"
    echo "Run the following to create it:"
    echo "  cd $PROJECT_DIR"
    echo "  python3 -m venv venv"
    echo "  source venv/bin/activate"
    echo "  pip install -r requirements.txt"
    exit 1
fi

# Activate the virtual environment
echo "📁 Project directory: $PROJECT_DIR"
echo "🔄 Activating virtual environment..."

cd "$PROJECT_DIR"
source venv/bin/activate

echo "✅ Virtual environment activated!"
echo "🐍 Python version: $(python --version)"
echo "📦 Installed packages: $(pip list | wc -l | tr -d ' ') packages"

echo ""
echo "🚀 You can now run DSAssist with Python integration:"
echo "   julia --project=. src/main.jl"
echo ""
echo "💡 To deactivate the environment later, run: deactivate"
echo ""

# Keep the shell open with the environment activated
exec "$SHELL"