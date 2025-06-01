#!/bin/bash

set -e

# Define virtual environment path
VENV_PATH="$(pwd)/.venv"
PYTHON_PATH="$VENV_PATH/bin/python"
SETTINGS_DIR=".vscode"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"

# Check if venv exists
if [ ! -x "$PYTHON_PATH" ]; then
    echo "Virtual environment not found at $PYTHON_PATH. Run your setup script first."
    exit 1
fi

# Create .vscode if it doesn't exist
mkdir -p "$SETTINGS_DIR"

# Clean up previous python.pythonPath setting if it exists
if [ -f "$SETTINGS_FILE" ]; then
    if command -v jq &>/dev/null; then
        tmpfile=$(mktemp)
        jq 'del(.["python.pythonPath"])' "$SETTINGS_FILE" > "$tmpfile" && mv "$tmpfile" "$SETTINGS_FILE"
    else
        echo "Warning: jq not found. Skipping removal of python.pythonPath from $SETTINGS_FILE."
    fi
fi

# Overwrite settings.json with only project-specific interpreter settings
cat > "$SETTINGS_FILE" <<EOF
{
    "python.defaultInterpreterPath": "$PYTHON_PATH",
    "python.terminal.activateEnvironment": true,
    "jupyter.pythonInterpreterPath": "$PYTHON_PATH"
}
EOF

echo "VS Code configured to use the virtual environment at $PYTHON_PATH for this project."
echo "Restart VS Code or reload the window (Ctrl+Shift+P → Reload Window) to apply changes."
