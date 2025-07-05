# awesome-ai


## Claude
### Resources
- Collection https://github.com/hesreallyhim/awesome-claude-code
- Claude commands and hooks used from https://github.com/Veraticus/nix-config/blob/main/home-manager/claude-code/CLAUDE.md

### Configuration Hierarchy

  1. Global (Home Directory)
  - ~/.claude/CLAUDE.md - Global development guidelines
  - ~/.claude/commands/ - Global slash commands
  - ~/.claude/hooks/ - Global hooks
  - ~/.config/claude-code/settings.json - Global settings

  2. Project-Level Override
  - ./CLAUDE.md - Project-specific guidelines (overrides global)
  - ./.claude/commands/ - Project-specific commands
  - ./.claude/hooks/ - Project-specific hooks
  - ./.claude-hooks-config.sh - Project-specific hook configuration

## Setup

## Install Script
### Run the setup
```
chmod +x setup-claude-code.sh
./setup-claude-code.sh
```

  ### See what it would do (dry run)
  ```
  ./setup-claude-code.sh --dry-run
  ```

  ### Show help
  ```
  ./setup-claude-code.sh --help
  ```


 ## Manual Setup
  ### 1. Install the hook script:
  ```
  mkdir -p ~/.claude/hooks
  cp claude/hooks/smart-lint.sh ~/.claude/hooks/
  chmod +x ~/.claude/hooks/smart-lint.sh
  ```
  ### 2. Copy configuration files:
  ```
  cp -r claude/CLAUDE.md ~/.claude/
  cp -r claude/commands ~/.claude/
  ```

  ### 3. Install language-specific tools:
  #### For Go projects
  ```
  go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
  ```

  #### For Python 
  ```
  pip install black ruff
  ```

  #### For JavaScript/TypeScript
  ```
  npm install -g eslint prettier
  ```
  
  #### For Rust
  ```
  rustup component add clippy rustfmt
  ```

  ### 4. Configure Claude Code to use hooks:
  Add to your `~/.config/claude-code/settings.json`:
  ```
  {
    "hooks": {
      "afterEdit": ["~/.claude/hooks/smart-lint.sh"],
      "afterTask": ["~/.claude/hooks/smart-lint.sh"]
    }
  }
```
  ### 5. Test the setup:
  ```
  cd your-project
  ~/.claude/hooks/smart-lint.sh
  ```

  The system will automatically detect your project type and run appropriate linters/formatters,
  enforcing zero-tolerance quality standards as described in the CLAUDE.md file.

## Copilot
https://github.com/github/awesome-copilot

###  Configuration
  Global Only:
  - Chatmodes and instructions are installed globally in VS Code's configuration directory
  - They apply to all projects when using VS Code with GitHub Copilot
  - No project-level overrides for chatmodes/instructions

## Setup
### Run the setup
```
chmod +x setup-copilot.sh
./setup-copilot.sh
```
  ### See what it would do (dry run)
  ```
  ./setup-copilot.sh --dry-run
  ```

  ### Test existing installation
  ```
  ./setup-copilot.sh --test
  ```

  ### Show help
  ```
  ./setup-copilot.sh --help
  ```
