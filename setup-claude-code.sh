#!/bin/bash
# setup-claude-code.sh - Automated setup script for Claude Code quality system
#
# This script sets up the Claude Code hooks and configuration system
# as outlined in the README.md file.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if we're in the correct directory
check_directory() {
    if [[ ! -d "claude" ]]; then
        log_error "claude/ directory not found. Please run this script from the ai-instructions directory."
        exit 1
    fi
    
    if [[ ! -f "claude/hooks/smart-lint.sh" ]]; then
        log_error "claude/hooks/smart-lint.sh not found. Please ensure the claude directory is properly set up."
        exit 1
    fi
}

# Step 1: Install hook script
install_hooks() {
    log_info "Installing Claude Code hooks..."
    
    mkdir -p ~/.claude/hooks
    cp claude/hooks/smart-lint.sh ~/.claude/hooks/
    chmod +x ~/.claude/hooks/smart-lint.sh
    
    log_success "Hook script installed to ~/.claude/hooks/"
}

# Step 2: Copy configuration files
copy_config() {
    log_info "Copying configuration files..."
    
    cp claude/CLAUDE.md ~/.claude/
    cp -r claude/commands ~/.claude/
    
    # Copy example files (optional)
    if [[ -f "claude/hooks/example-claude-hooks-config" ]]; then
        cp claude/hooks/example-claude-hooks-config ~/.claude/hooks/
    fi
    
    if [[ -f "claude/hooks/example-claude-hooks-ignore" ]]; then
        cp claude/hooks/example-claude-hooks-ignore ~/.claude/hooks/
    fi
    
    log_success "Configuration files copied to ~/.claude/"
}

# Step 3: Install language-specific tools
install_language_tools() {
    log_info "Installing language-specific tools..."
    
    # Go tools
    if command_exists go; then
        log_info "Installing Go tools..."
        go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
        log_success "Go tools installed"
    else
        log_warn "Go not found, skipping Go tools installation"
    fi
    
    # Python tools
    if command_exists pip; then
        log_info "Installing Python tools..."
        pip install black ruff
        log_success "Python tools installed"
    elif command_exists pip3; then
        log_info "Installing Python tools..."
        pip3 install black ruff
        log_success "Python tools installed"
    else
        log_warn "pip not found, skipping Python tools installation"
    fi
    
    # JavaScript/TypeScript tools
    if command_exists npm; then
        log_info "Installing JavaScript/TypeScript tools..."
        npm install -g eslint prettier
        log_success "JavaScript/TypeScript tools installed"
    else
        log_warn "npm not found, skipping JavaScript/TypeScript tools installation"
    fi
    
    # Rust tools
    if command_exists rustup; then
        log_info "Installing Rust tools..."
        rustup component add clippy rustfmt
        log_success "Rust tools installed"
    else
        log_warn "rustup not found, skipping Rust tools installation"
    fi
}

# Step 4: Configure Claude Code settings
configure_claude_code() {
    log_info "Configuring Claude Code settings..."
    
    local settings_dir="$HOME/.config/claude-code"
    local settings_file="$settings_dir/settings.json"
    
    mkdir -p "$settings_dir"
    
    # Create or update settings.json
    if [[ -f "$settings_file" ]]; then
        log_info "Existing settings.json found, backing up..."
        cp "$settings_file" "$settings_file.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Create the settings JSON
    cat > "$settings_file" << 'EOF'
{
  "hooks": {
    "afterEdit": ["~/.claude/hooks/smart-lint.sh"],
    "afterTask": ["~/.claude/hooks/smart-lint.sh"]
  }
}
EOF
    
    log_success "Claude Code settings configured"
}

# Step 5: Test the setup
test_setup() {
    log_info "Testing the setup..."
    
    if [[ -x ~/.claude/hooks/smart-lint.sh ]]; then
        log_success "Hook script is executable"
    else
        log_error "Hook script is not executable"
        return 1
    fi
    
    if [[ -f ~/.claude/CLAUDE.md ]]; then
        log_success "CLAUDE.md configuration found"
    else
        log_error "CLAUDE.md configuration missing"
        return 1
    fi
    
    if [[ -d ~/.claude/commands ]]; then
        log_success "Commands directory found"
    else
        log_error "Commands directory missing"
        return 1
    fi
    
    # Test the hook script
    log_info "Running hook script test..."
    if ~/.claude/hooks/smart-lint.sh --help >/dev/null 2>&1; then
        log_success "Hook script test passed"
    else
        log_warn "Hook script test failed (this might be normal if no supported project files are present)"
    fi
    
    log_success "Setup test completed"
}

# Main execution
main() {
    echo "Claude Code Quality System Setup"
    echo "================================"
    echo ""
    
    check_directory
    install_hooks
    copy_config
    install_language_tools
    configure_claude_code
    test_setup
    
    echo ""
    echo "Setup completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Navigate to a project directory"
    echo "2. Run: ~/.claude/hooks/smart-lint.sh"
    echo "3. The system will automatically detect your project type and run appropriate linters"
    echo ""
    echo "For more information, see ~/.claude/CLAUDE.md"
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --dry-run      Show what would be done without actually doing it"
        echo ""
        echo "This script sets up the Claude Code quality system by:"
        echo "1. Installing hook scripts to ~/.claude/hooks/"
        echo "2. Copying configuration files to ~/.claude/"
        echo "3. Installing language-specific tools (Go, Python, JS/TS, Rust)"
        echo "4. Configuring Claude Code settings"
        echo "5. Testing the setup"
        exit 0
        ;;
    --dry-run)
        echo "DRY RUN MODE - No changes will be made"
        echo ""
        echo "Would perform the following actions:"
        echo "1. Create ~/.claude/hooks/ and copy smart-lint.sh"
        echo "2. Copy CLAUDE.md and commands/ to ~/.claude/"
        echo "3. Install language tools (if available): golangci-lint, black, ruff, eslint, prettier, clippy, rustfmt"
        echo "4. Create/update ~/.config/claude-code/settings.json"
        echo "5. Test the installation"
        exit 0
        ;;
    "")
        main
        ;;
    *)
        echo "Unknown option: $1"
        echo "Use --help for usage information"
        exit 1
        ;;
esac