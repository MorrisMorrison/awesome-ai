#!/bin/bash
# setup-copilot.sh - Automated setup script for GitHub Copilot chatmodes and instructions
#
# This script sets up the GitHub Copilot chatmodes and language-specific instructions
# for VS Code and other compatible editors.

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

# Check if VS Code is installed
check_vscode() {
    if command_exists code; then
        return 0
    elif command_exists code-insiders; then
        return 0
    else
        return 1
    fi
}

# Check if we're in the correct directory
check_directory() {
    if [[ ! -d "copilot" ]]; then
        log_error "copilot/ directory not found. Please run this script from the ai-instructions directory."
        exit 1
    fi
    
    if [[ ! -d "copilot/chatmodes" ]]; then
        log_error "copilot/chatmodes/ directory not found. Please ensure the copilot directory is properly set up."
        exit 1
    fi
    
    if [[ ! -d "copilot/instructions" ]]; then
        log_error "copilot/instructions/ directory not found. Please ensure the copilot directory is properly set up."
        exit 1
    fi
}

# Detect VS Code configuration directory
get_vscode_config_dir() {
    local config_dir=""
    
    # Check for different VS Code installations and platforms
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS
        if [[ -d "$HOME/Library/Application Support/Code/User" ]]; then
            config_dir="$HOME/Library/Application Support/Code/User"
        elif [[ -d "$HOME/Library/Application Support/Code - Insiders/User" ]]; then
            config_dir="$HOME/Library/Application Support/Code - Insiders/User"
        fi
    elif [[ "$(uname)" == "Linux" ]]; then
        # Linux
        if [[ -d "$HOME/.config/Code/User" ]]; then
            config_dir="$HOME/.config/Code/User"
        elif [[ -d "$HOME/.config/Code - Insiders/User" ]]; then
            config_dir="$HOME/.config/Code - Insiders/User"
        fi
    elif [[ "$(uname)" =~ MINGW* ]] || [[ "$(uname)" =~ CYGWIN* ]]; then
        # Windows (Git Bash/Cygwin)
        if [[ -d "$APPDATA/Code/User" ]]; then
            config_dir="$APPDATA/Code/User"
        elif [[ -d "$APPDATA/Code - Insiders/User" ]]; then
            config_dir="$APPDATA/Code - Insiders/User"
        fi
    fi
    
    echo "$config_dir"
}

# Install chatmodes
install_chatmodes() {
    log_info "Installing GitHub Copilot chatmodes..."
    
    local vscode_config_dir=$(get_vscode_config_dir)
    
    if [[ -z "$vscode_config_dir" ]]; then
        log_error "VS Code configuration directory not found. Please ensure VS Code is installed."
        return 1
    fi
    
    local chatmodes_dir="$vscode_config_dir/copilot_chatmodes"
    
    # Create chatmodes directory
    mkdir -p "$chatmodes_dir"
    
    # Copy all chatmode files
    local chatmode_count=0
    for chatmode_file in copilot/chatmodes/*.chatmode.md; do
        if [[ -f "$chatmode_file" ]]; then
            cp "$chatmode_file" "$chatmodes_dir/"
            ((chatmode_count++))
            log_info "Installed: $(basename "$chatmode_file")"
        fi
    done
    
    if [[ $chatmode_count -gt 0 ]]; then
        log_success "Installed $chatmode_count chatmode(s) to $chatmodes_dir"
    else
        log_warn "No chatmode files found to install"
    fi
}

# Install instructions
install_instructions() {
    log_info "Installing GitHub Copilot instructions..."
    
    local vscode_config_dir=$(get_vscode_config_dir)
    
    if [[ -z "$vscode_config_dir" ]]; then
        log_error "VS Code configuration directory not found. Please ensure VS Code is installed."
        return 1
    fi
    
    local instructions_dir="$vscode_config_dir/copilot_instructions"
    
    # Create instructions directory
    mkdir -p "$instructions_dir"
    
    # Copy all instruction files
    local instruction_count=0
    for instruction_file in copilot/instructions/*.instructions.md; do
        if [[ -f "$instruction_file" ]]; then
            cp "$instruction_file" "$instructions_dir/"
            ((instruction_count++))
            log_info "Installed: $(basename "$instruction_file")"
        fi
    done
    
    if [[ $instruction_count -gt 0 ]]; then
        log_success "Installed $instruction_count instruction file(s) to $instructions_dir"
    else
        log_warn "No instruction files found to install"
    fi
}

# Copy standalone instruction files
copy_standalone_instructions() {
    log_info "Copying standalone instruction files..."
    
    local vscode_config_dir=$(get_vscode_config_dir)
    
    if [[ -z "$vscode_config_dir" ]]; then
        log_error "VS Code configuration directory not found. Please ensure VS Code is installed."
        return 1
    fi
    
    local standalone_dir="$vscode_config_dir/copilot_standalone"
    mkdir -p "$standalone_dir"
    
    # Copy standalone instruction files
    local standalone_count=0
    for standalone_file in *_copilot_instructions.md; do
        if [[ -f "$standalone_file" ]]; then
            cp "$standalone_file" "$standalone_dir/"
            ((standalone_count++))
            log_info "Copied: $(basename "$standalone_file")"
        fi
    done
    
    # Copy template file
    if [[ -f "claude_instructions_template.md" ]]; then
        cp "claude_instructions_template.md" "$standalone_dir/"
        ((standalone_count++))
        log_info "Copied: claude_instructions_template.md"
    fi
    
    if [[ $standalone_count -gt 0 ]]; then
        log_success "Copied $standalone_count standalone file(s) to $standalone_dir"
    else
        log_warn "No standalone instruction files found to copy"
    fi
}

# Check GitHub Copilot extension
check_copilot_extension() {
    log_info "Checking GitHub Copilot extension..."
    
    local vscode_config_dir=$(get_vscode_config_dir)
    
    if [[ -z "$vscode_config_dir" ]]; then
        log_warn "Cannot check for Copilot extension - VS Code config directory not found"
        return 1
    fi
    
    # Check if extensions directory exists
    local extensions_dir="$(dirname "$vscode_config_dir")/extensions"
    
    if [[ -d "$extensions_dir" ]]; then
        # Look for GitHub Copilot extension
        if find "$extensions_dir" -name "*github.copilot*" -type d | head -1 | grep -q .; then
            log_success "GitHub Copilot extension found"
            return 0
        else
            log_warn "GitHub Copilot extension not found"
            log_info "Please install the GitHub Copilot extension from the VS Code marketplace"
            return 1
        fi
    else
        log_warn "Extensions directory not found: $extensions_dir"
        return 1
    fi
}

# Display usage information
show_usage() {
    log_info "GitHub Copilot Setup Complete!"
    echo ""
    echo "What was installed:"
    echo "• Chatmodes: Custom chat modes for different coding scenarios"
    echo "• Instructions: Language-specific coding guidelines"
    echo "• Standalone files: Individual instruction files for reference"
    echo ""
    echo "Next steps:"
    echo "1. Restart VS Code to load the new configurations"
    echo "2. Open GitHub Copilot Chat in VS Code (Ctrl+Alt+I or Cmd+Alt+I)"
    echo "3. Use '@' to select chatmodes or reference instructions"
    echo "4. Try chatmodes like '4.1 Beast Mode' or 'Planner' for specialized assistance"
    echo ""
    echo "Available chatmodes:"
    for chatmode_file in copilot/chatmodes/*.chatmode.md; do
        if [[ -f "$chatmode_file" ]]; then
            local title=$(grep "^title:" "$chatmode_file" | sed "s/title: *'\\(.*\\)'/\\1/")
            echo "• $title"
        fi
    done
    echo ""
    echo "Available instructions:"
    for instruction_file in copilot/instructions/*.instructions.md; do
        if [[ -f "$instruction_file" ]]; then
            local desc=$(grep "^description:" "$instruction_file" | sed "s/description: *'\\(.*\\)'/\\1/")
            echo "• $(basename "$instruction_file" .instructions.md): $desc"
        fi
    done
}

# Test the installation
test_installation() {
    log_info "Testing installation..."
    
    local vscode_config_dir=$(get_vscode_config_dir)
    
    if [[ -z "$vscode_config_dir" ]]; then
        log_error "VS Code configuration directory not found"
        return 1
    fi
    
    local chatmodes_dir="$vscode_config_dir/copilot_chatmodes"
    local instructions_dir="$vscode_config_dir/copilot_instructions"
    
    # Test chatmodes
    if [[ -d "$chatmodes_dir" ]]; then
        local chatmode_count=$(find "$chatmodes_dir" -name "*.chatmode.md" | wc -l)
        log_success "Found $chatmode_count chatmode file(s)"
    else
        log_error "Chatmodes directory not found: $chatmodes_dir"
        return 1
    fi
    
    # Test instructions
    if [[ -d "$instructions_dir" ]]; then
        local instruction_count=$(find "$instructions_dir" -name "*.instructions.md" | wc -l)
        log_success "Found $instruction_count instruction file(s)"
    else
        log_error "Instructions directory not found: $instructions_dir"
        return 1
    fi
    
    log_success "Installation test completed successfully"
}

# Main execution
main() {
    echo "GitHub Copilot Setup Script"
    echo "==========================="
    echo ""
    
    check_directory
    
    if ! check_vscode; then
        log_error "VS Code not found. Please install VS Code first."
        exit 1
    fi
    
    install_chatmodes
    install_instructions
    copy_standalone_instructions
    check_copilot_extension
    test_installation
    
    echo ""
    show_usage
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --dry-run      Show what would be done without actually doing it"
        echo "  --test         Test existing installation"
        echo ""
        echo "This script sets up GitHub Copilot chatmodes and instructions by:"
        echo "1. Installing chatmode files to VS Code configuration directory"
        echo "2. Installing instruction files to VS Code configuration directory"
        echo "3. Copying standalone instruction files for reference"
        echo "4. Checking for GitHub Copilot extension"
        echo "5. Testing the installation"
        exit 0
        ;;
    --dry-run)
        echo "DRY RUN MODE - No changes will be made"
        echo ""
        echo "Would perform the following actions:"
        echo "1. Install chatmode files from copilot/chatmodes/ to VS Code config"
        echo "2. Install instruction files from copilot/instructions/ to VS Code config"
        echo "3. Copy standalone instruction files to VS Code config"
        echo "4. Check for GitHub Copilot extension"
        echo "5. Test the installation"
        echo ""
        local vscode_config_dir=$(get_vscode_config_dir)
        echo "Target VS Code config directory: ${vscode_config_dir:-'NOT FOUND'}"
        exit 0
        ;;
    --test)
        echo "Testing existing installation..."
        echo ""
        check_directory
        test_installation
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