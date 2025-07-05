# awesome-ai


## Claude
### Resources
- https://github.com/hesreallyhim/awesome-claude-code
- https://github.com/Veraticus/nix-config/blob/main/home-manager/claude-code/CLAUDE.md


## Setup
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