#!/bin/bash

set -e

echo "Step 0: Ensure ~/.local/bin is in PATH"
export PATH="$HOME/.local/bin:$PATH"

echo "Step 1: Install system packages"
sudo dnf install -y \
    python3.12 \
    python3.12-devel \
    gcc-c++ \
    make \
    cmake \
    libcurl-devel \
    wget

echo "Step 2: Enable CodeReady Builder (optional)"
sudo subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms || true

echo "Step 3: Install uv (Python package manager)"
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "Step 4: Add uv to PATH for current shell session"
export PATH="$HOME/.local/bin:$PATH"

echo "Step 5: Create Python 3.12 virtual environment using uv"
uv venv --python $(which python3.12)

echo "Step 6: Activate virtual environment"
source .venv/bin/activate

echo "Step 7: Install llama-cpp-python from source"
export LLAMA_CPP_CMAKE_ARGS="-DLLAMA_NATIVE=ON"
uv pip install llama-cpp-python --no-binary :all:

echo "Step 8: Install huggingface-hub"
uv pip install huggingface-hub

echo "Step 9: Download GGUF embedding model"
mkdir -p models
cd models
wget -O granite-embedding-30m-english-Q6_K.gguf \
  https://huggingface.co/lmstudio-community/granite-embedding-30m-english-GGUF/resolve/main/granite-embedding-30m-english-Q6_K.gguf
cd ..

echo "Step 10: Install additional Python dependencies from requirements.txt (if present)"
if [ -f requirements.txt ]; then
    uv pip install -r requirements.txt
else
    echo "requirements.txt not found — skipping."
fi

echo ""
echo "Setup complete."
echo ""
echo "To activate the environment, run:"
echo "    source .venv/bin/activate"
echo ""
echo "Then run your Python code or open the notebook:"
echo "    python"
echo "    jupyter notebook text-embedding.ipynb"