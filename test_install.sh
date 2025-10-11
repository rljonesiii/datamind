#!/bin/bash

# Test script for install.sh using Docker containers
# This creates clean environments to test the installation process

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Test on Ubuntu
test_ubuntu() {
    log_info "Testing installation on Ubuntu..."
    
    docker run --rm -v "$(pwd)":/datamind -w /datamind ubuntu:22.04 bash -c "
        apt-get update && apt-get install -y curl wget python3 python3-venv python3-pip
        ./install.sh
    "
    
    if [ $? -eq 0 ]; then
        log_success "Ubuntu test passed"
    else
        log_error "Ubuntu test failed"
        return 1
    fi
}

# Test on macOS (if available)
test_macos() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        log_info "Testing installation on macOS (current system)..."
        
        # Create a temporary test directory
        TEST_DIR="/tmp/datamind_test_$(date +%s)"
        cp -r . "$TEST_DIR"
        cd "$TEST_DIR"
        
        # Run the installer
        ./install.sh
        
        if [ $? -eq 0 ]; then
            log_success "macOS test passed"
            rm -rf "$TEST_DIR"
        else
            log_error "macOS test failed"
            log_info "Test directory preserved at: $TEST_DIR"
            return 1
        fi
    else
        log_info "Skipping macOS test (not running on macOS)"
    fi
}

# Test with dry run mode
test_dry_run() {
    log_info "Testing script validation (dry run)..."
    
    # Check script syntax
    bash -n install.sh
    if [ $? -eq 0 ]; then
        log_success "Bash syntax validation passed"
    else
        log_error "Bash syntax validation failed"
        return 1
    fi
}

# Main test function
main() {
    log_info "🧪 Starting installation script tests..."
    
    # Check if Docker is available
    if command -v docker >/dev/null 2>&1; then
        test_ubuntu
    else
        log_info "Docker not available, skipping container tests"
    fi
    
    test_dry_run
    test_macos
    
    log_success "All tests completed!"
}

main "$@"