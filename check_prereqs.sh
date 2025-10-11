#!/bin/bash

# Simple dependency and environment checker for DataMind
# This tests what would happen without actually installing anything

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[CHECK]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "🔍 DataMind Installation Prerequisites Check"
echo "============================================="

# Check OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
fi
log_info "Operating System: $OS"

# Check Julia
if command_exists julia; then
    VERSION=$(julia --version 2>/dev/null || echo "unknown")
    log_success "Julia found: $VERSION"
else
    log_warning "Julia not found - will be installed"
    if [[ "$OS" == "macOS" ]]; then
        if command_exists brew; then
            log_info "  → Can install via Homebrew"
        else
            log_info "  → Will install manually from JuliaLang.org"
        fi
    elif [[ "$OS" == "Linux" ]]; then
        if command_exists apt-get; then
            log_info "  → Can install via apt"
        elif command_exists dnf; then
            log_info "  → Can install via dnf"
        else
            log_info "  → Will install manually from JuliaLang.org"
        fi
    fi
fi

# Check Python
if command_exists python3; then
    VERSION=$(python3 --version 2>&1)
    log_success "Python found: $VERSION"
    
    # Check if venv module is available
    if python3 -m venv --help >/dev/null 2>&1; then
        log_success "Python venv module available"
    else
        log_error "Python venv module not available"
    fi
else
    log_error "Python 3 not found - please install Python 3.8+ first"
fi

# Check existing virtual environment
if [[ -d ".venv" ]]; then
    log_warning "Virtual environment (.venv) already exists"
else
    log_info "Virtual environment will be created"
fi

# Check existing .env file
if [[ -f ".env" ]]; then
    log_warning ".env file already exists"
else
    log_info ".env template will be created"
fi

# Check Project.toml
if [[ -f "Project.toml" ]]; then
    log_success "Julia Project.toml found"
else
    log_error "Project.toml not found - are you in the DataMind directory?"
fi

# Check internet connectivity
if curl -s --head google.com >/dev/null 2>&1; then
    log_success "Internet connectivity available"
else
    log_error "No internet connectivity - installation will fail"
fi

# Check disk space (rough estimate)
if [[ "$OS" == "macOS" ]] || [[ "$OS" == "Linux" ]]; then
    AVAILABLE=$(df . | tail -1 | awk '{print $4}')
    if [[ $AVAILABLE -gt 1000000 ]]; then  # > 1GB
        log_success "Sufficient disk space available"
    else
        log_warning "Low disk space - may need more room for packages"
    fi
fi

echo ""
echo "🎯 What the installation script will do:"
echo "----------------------------------------"
echo "1. Install Julia (if not present)"
echo "2. Create Python virtual environment (.venv)"
echo "3. Install Python packages: ChromaDB, OpenAI, pandas, etc."
echo "4. Setup Julia package environment"
echo "5. Create .env configuration file"
echo "6. Run verification tests"
echo ""
echo "To proceed with installation, run: ./install.sh"
echo "For a dry run (see what would happen): ./install.sh --dry-run"