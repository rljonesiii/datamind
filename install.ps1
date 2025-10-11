# DataMind Installation Script for Windows PowerShell
# This script installs all prerequisites for DataMind including Julia, Python dependencies, and environment setup

# Enable strict mode
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Colors for output
$Colors = @{
    Red = "Red"
    Green = "Green" 
    Yellow = "Yellow"
    Blue = "Blue"
    White = "White"
}

# Logging functions
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $Colors.Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $Colors.Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $Colors.Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $Colors.Red
}

# Function to check if command exists
function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Function to check if running as administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to install Chocolatey
function Install-Chocolatey {
    Write-Info "Installing Chocolatey package manager..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    refreshenv
}

# Function to install Julia
function Install-Julia {
    Write-Info "Installing Julia..."
    
    # Try Chocolatey first
    if (Test-Command "choco") {
        Write-Info "Using Chocolatey to install Julia..."
        choco install julia -y
        refreshenv
    } elseif (Test-Command "winget") {
        Write-Info "Using winget to install Julia..."
        winget install julia -e --source winget
    } else {
        Write-Info "Installing Chocolatey first..."
        Install-Chocolatey
        choco install julia -y
        refreshenv
    }
}

# Function to install Python dependencies
function Install-PythonDeps {
    Write-Info "Setting up Python environment..."
    
    # Check if Python is available
    if (-not (Test-Command "python")) {
        Write-Error-Custom "Python is required but not installed. Please install Python 3.8+ first."
        Write-Info "You can install Python using: choco install python"
        exit 1
    }
    
    $pythonVersion = python --version 2>&1
    Write-Info "Found Python: $pythonVersion"
    
    # Create virtual environment
    Write-Info "Creating Python virtual environment (.venv)..."
    python -m venv .venv
    
    # Activate virtual environment
    Write-Info "Activating virtual environment..."
    & ".\.venv\Scripts\Activate.ps1"
    
    # Upgrade pip
    Write-Info "Upgrading pip..."
    python -m pip install --upgrade pip
    
    # Create requirements file
    Write-Info "Installing Python dependencies..."
    $requirements = @"
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
"@
    
    $requirements | Out-File -FilePath "requirements.txt" -Encoding UTF8
    pip install -r requirements.txt
    
    Write-Success "Python environment setup complete"
}

# Function to setup Julia environment
function Set-JuliaEnvironment {
    Write-Info "Setting up Julia environment..."
    
    # Install Julia packages
    Write-Info "Installing Julia packages..."
    julia --project=. -e "
        using Pkg
        Pkg.instantiate()
        Pkg.precompile()
    "
    
    Write-Success "Julia environment setup complete"
}

# Function to create .env file
function New-EnvFile {
    Write-Info "Setting up environment configuration..."
    
    if (-not (Test-Path ".env")) {
        Write-Info "Creating .env file..."
        $envContent = @"
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
"@
        $envContent | Out-File -FilePath ".env" -Encoding UTF8
        Write-Success "Created .env file. Please edit it with your API keys."
    } else {
        Write-Info ".env file already exists, skipping creation"
    }
}

# Function to run verification
function Test-Installation {
    Write-Info "Verifying installation..."
    
    # Check Julia
    if (Test-Command "julia") {
        $juliaVersion = julia --version 2>&1
        Write-Success "Julia installed: $juliaVersion"
    } else {
        Write-Error-Custom "Julia installation failed"
        return $false
    }
    
    # Check Python environment
    if (Test-Path ".venv\Scripts\Activate.ps1") {
        & ".\.venv\Scripts\Activate.ps1"
        try {
            python -c "import chromadb; print('ChromaDB version:', chromadb.__version__)" 2>$null
            Write-Success "Python environment with ChromaDB ready"
        } catch {
            Write-Error-Custom "Python environment setup failed"
            return $false
        }
    } else {
        Write-Error-Custom "Python virtual environment not found"
        return $false
    }
    
    # Test basic Julia functionality
    Write-Info "Testing Julia package loading..."
    try {
        julia --project=. -e "using DataMind" 2>$null
        Write-Success "Julia DataMind package loads successfully"
    } catch {
        Write-Warning "Julia DataMind package test failed (may need API keys)"
    }
    
    Write-Success "Installation verification complete!"
    return $true
}

# Function to show next steps
function Show-NextSteps {
    Write-Host ""
    Write-Info "🎉 DataMind installation complete!"
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "1. Edit the .env file with your OpenAI API key:"
    Write-Host "   notepad .env" -ForegroundColor $Colors.Blue
    Write-Host ""
    Write-Host "2. Activate the Python environment:"
    Write-Host "   .\.venv\Scripts\Activate.ps1" -ForegroundColor $Colors.Blue
    Write-Host ""
    Write-Host "3. Test the installation:"
    Write-Host "   julia --project=. scripts\diagnostic.jl" -ForegroundColor $Colors.Blue
    Write-Host ""
    Write-Host "4. Run your first analysis:"
    Write-Host "   julia --project=. scripts\direct_analysis.jl `"Analyze my data`"" -ForegroundColor $Colors.Blue
    Write-Host ""
    Write-Host "5. Explore demos:"
    Write-Host "   julia --project=. scripts\demos\agentic_guided_tour\basic_usage.jl" -ForegroundColor $Colors.Blue
    Write-Host ""
    Write-Info "For help: see README.md or docs\README.md"
}

# Main installation function
function Start-Installation {
    Write-Host ""
    Write-Info "🚀 Starting DataMind installation..."
    Write-Host ""
    
    # Check if Julia is installed
    if (Test-Command "julia") {
        $juliaVersion = julia --version 2>&1
        Write-Success "Julia already installed: $juliaVersion"
    } else {
        Write-Info "Julia not found, installing..."
        Install-Julia
    }
    
    # Install Python dependencies
    Install-PythonDeps
    
    # Setup Julia environment
    Set-JuliaEnvironment
    
    # Create environment file
    New-EnvFile
    
    # Verify installation
    if (Test-Installation) {
        Show-NextSteps
    } else {
        Write-Error-Custom "Installation verification failed. Please check the errors above."
        exit 1
    }
}

# Check if we're in the right directory
if (-not (Test-Path "Project.toml") -or -not (Test-Path "src")) {
    Write-Error-Custom "Please run this script from the DataMind project root directory"
    exit 1
}

# Check if running as administrator for some operations
if (-not (Test-Administrator)) {
    Write-Warning "Some operations may require administrator privileges. Consider running as administrator if installation fails."
}

# Run main installation
try {
    Start-Installation
} catch {
    Write-Error-Custom "Installation failed: $($_.Exception.Message)"
    Write-Host "Stack trace: $($_.ScriptStackTrace)" -ForegroundColor $Colors.Red
    exit 1
}