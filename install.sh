#!/bin/bash

# DataMind Installation Script for macOS/Linux
# This script installs all prerequisites for DataMind including Julia, Python dependencies, and environment setup

set -e  # Exit on any error

# Global variables
DRY_RUN=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            echo "DataMind Installation Script"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run    Show what would be installed without making changes"
            echo "  --help, -h   Show this help message"
            echo ""
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to execute or simulate command
execute_or_simulate() {
    local description="$1"
    shift
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would execute: $description"
        echo "  Command: $*"
    else
        log_info "$description"
        "$@"
    fi
}

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   log_error "This script should not be run as root"
   exit 1
fi

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    log_error "Unsupported operating system: $OSTYPE"
    exit 1
fi

log_info "Detected OS: $OS"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Julia on macOS
install_julia_macos() {
    log_info "Installing Julia on macOS..."
    
    if command_exists brew; then
        log_info "Using Homebrew to install Julia..."
        brew install julia
    else
        log_warning "Homebrew not found. Installing Julia manually..."
        
        # Get latest Julia version
        JULIA_VERSION="1.10.5"  # You can update this to latest stable
        JULIA_URL="https://julialang-s3.julialang.org/bin/mac/x64/1.10/julia-${JULIA_VERSION}-mac64.dmg"
        
        log_info "Downloading Julia ${JULIA_VERSION}..."
        curl -L -o /tmp/julia.dmg "$JULIA_URL"
        
        log_info "Mounting Julia installer..."
        hdiutil attach /tmp/julia.dmg
        
        log_info "Installing Julia to /Applications..."
        cp -R /Volumes/Julia-*/Julia-*.app /Applications/
        
        log_info "Creating symlink to Julia binary..."
        sudo mkdir -p /usr/local/bin
        sudo ln -sf /Applications/Julia-*.app/Contents/Resources/julia/bin/julia /usr/local/bin/julia
        
        log_info "Cleaning up..."
        hdiutil detach /Volumes/Julia-*
        rm /tmp/julia.dmg
    fi
}

# Function to install Julia on Linux
install_julia_linux() {
    log_info "Installing Julia on Linux..."
    
    # Try package manager first
    if command_exists apt-get; then
        log_info "Using apt to install Julia..."
        sudo apt-get update
        sudo apt-get install -y julia
    elif command_exists dnf; then
        log_info "Using dnf to install Julia..."
        sudo dnf install -y julia
    elif command_exists yum; then
        log_info "Using yum to install Julia..."
        sudo yum install -y julia
    elif command_exists pacman; then
        log_info "Using pacman to install Julia..."
        sudo pacman -S julia
    else
        log_warning "No supported package manager found. Installing Julia manually..."
        
        # Manual installation
        JULIA_VERSION="1.10.5"
        JULIA_URL="https://julialang-s3.julialang.org/bin/linux/x64/1.10/julia-${JULIA_VERSION}-linux-x86_64.tar.gz"
        
        log_info "Downloading Julia ${JULIA_VERSION}..."
        wget -O /tmp/julia.tar.gz "$JULIA_URL"
        
        log_info "Extracting Julia..."
        sudo tar -xzf /tmp/julia.tar.gz -C /opt/
        sudo mv /opt/julia-* /opt/julia
        
        log_info "Creating symlink..."
        sudo ln -sf /opt/julia/bin/julia /usr/local/bin/julia
        
        log_info "Cleaning up..."
        rm /tmp/julia.tar.gz
    fi
}

# Function to install Python dependencies
install_python_deps() {
    log_info "Setting up Python environment..."
    
    # Check if Python 3 is available
    if ! command_exists python3; then
        log_error "Python 3 is required but not installed. Please install Python 3 first."
        exit 1
    fi
    
    PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
    log_info "Found Python $PYTHON_VERSION"
    
    # Create virtual environment
    log_info "Creating Python virtual environment (.venv)..."
    python3 -m venv .venv
    
    # Activate virtual environment
    source .venv/bin/activate
    
    # Upgrade pip
    log_info "Upgrading pip..."
    pip install --upgrade pip
    
    # Install Python dependencies
    log_info "Installing Python dependencies..."
    cat > requirements.txt << 'EOF'
chromadb>=0.4.0
openai>=1.0.0
python-dotenv>=1.0.0
pyyaml>=6.0
requests>=2.25.0
neo4j>=5.0.0
pandas>=2.0.0
numpy>=1.24.0
scikit-learn>=1.3.0
matplotlib>=3.7.0
seaborn>=0.12.0
jupyter>=1.0.0
notebook>=7.0.0
plotly>=5.15.0
dash>=2.10.0
EOF
    
    pip install -r requirements.txt
    
    log_success "Python environment setup complete"
}

# Function to setup Julia environment
setup_julia_env() {
    log_info "Setting up Julia environment..."
    
    # Install Julia packages
    log_info "Installing Julia packages..."
    julia --project=. -e '
        using Pkg
        Pkg.instantiate()
        Pkg.precompile()
    '
    
    log_success "Julia environment setup complete"
}

# Function to create .env file
create_env_file() {
    log_info "Setting up environment configuration..."
    
    if [[ ! -f .env ]]; then
        log_info "Creating .env file..."
        cat > .env << 'EOF'
# DataMind Configuration
# Copy this file and add your actual API keys

# Required: OpenAI API key for GPT-4 integration
OPENAI_API_KEY=your_openai_api_key_here

# Optional: Additional LLM providers
ANTHROPIC_API_KEY=your_anthropic_api_key_here

# Optional: Performance tuning
JULIA_NUM_THREADS=4

# Optional: Development settings
DATAMIND_USE_MOCK_API=false

# Optional: Neo4j configuration (if using external Neo4j)
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=password
EOF
        log_success "Created .env file. Please edit it with your API keys."
    else
        log_info ".env file already exists, skipping creation"
    fi
}

# Function to run verification
verify_installation() {
    log_info "Verifying installation..."
    
    # Check Julia
    if command_exists julia; then
        JULIA_VERSION=$(julia --version 2>/dev/null || echo "unknown")
        log_success "Julia installed: $JULIA_VERSION"
    else
        log_error "Julia installation failed"
        return 1
    fi
    
    # Check Python environment
    if [[ -f .venv/bin/activate ]]; then
        source .venv/bin/activate
        if python -c "import chromadb; print('ChromaDB version:', chromadb.__version__)" 2>/dev/null; then
            log_success "Python environment with ChromaDB ready"
        else
            log_error "Python environment setup failed"
            return 1
        fi
    else
        log_error "Python virtual environment not found"
        return 1
    fi
    
    # Test basic Julia functionality
    log_info "Testing Julia package loading..."
    if julia --project=. -e "using DataMind" 2>/dev/null; then
        log_success "Julia DataMind package loads successfully"
    else
        log_warning "Julia DataMind package test failed (may need API keys)"
    fi
    
    log_success "Installation verification complete!"
    return 0
}

# Function to show next steps
show_next_steps() {
    echo ""
    log_info "🎉 DataMind installation complete!"
    echo ""
    echo "Next steps:"
    echo "1. Edit the .env file with your OpenAI API key:"
    echo "   ${BLUE}nano .env${NC}"
    echo ""
    echo "2. Activate the Python environment:"
    echo "   ${BLUE}source .venv/bin/activate${NC}"
    echo ""
    echo "3. Test the installation:"
    echo "   ${BLUE}./scripts/run.sh diagnostic.jl${NC}"
    echo ""
    echo "4. Run your first analysis:"
    echo "   ${BLUE}./scripts/run.sh direct_analysis.jl \"Analyze my data\"${NC}"
    echo ""
    echo "5. Explore demos:"
    echo "   ${BLUE}./scripts/run.sh demos/agentic_guided_tour/basic_usage.jl${NC}"
    echo ""
    log_info "For help: see README.md or docs/README.md"
}

# Main installation flow
main() {
    echo ""
    log_info "🚀 Starting DataMind installation..."
    echo ""
    
    # Check if Julia is installed
    if command_exists julia; then
        JULIA_VERSION=$(julia --version 2>/dev/null || echo "unknown")
        log_success "Julia already installed: $JULIA_VERSION"
    else
        log_info "Julia not found, installing..."
        if [[ "$OS" == "macos" ]]; then
            install_julia_macos
        elif [[ "$OS" == "linux" ]]; then
            install_julia_linux
        fi
    fi
    
    # Install Python dependencies
    install_python_deps
    
    # Setup Julia environment
    setup_julia_env
    
    # Create environment file
    create_env_file
    
    # Verify installation
    if verify_installation; then
        show_next_steps
    else
        log_error "Installation verification failed. Please check the errors above."
        exit 1
    fi
}

# Check if we're in the right directory
if [[ ! -f "Project.toml" ]] || [[ ! -d "src" ]]; then
    log_error "Please run this script from the DataMind project root directory"
    exit 1
fi

# Run main installation
main "$@"