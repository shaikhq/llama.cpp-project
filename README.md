
# Generate Text Embeddings with Llama.cpp on Red Hat Linux (from Source)

Set up `llama-cpp-python` on Red Hat Linux 9.4, build it from source, and use a quantized GGUF model to generate text embeddings. This guide uses [`uv`](https://github.com/astral-sh/uv) for lightweight and reproducible Python environment management.

A sample notebook, [`text-embedding.ipynb`](./text-embedding.ipynb), is included to demonstrate end-to-end usage.

---

## Overview

You will:

- Set up a Python 3.12 development environment on RHEL
- Build `llama-cpp-python` from source
- Use `uv` to manage your Python virtual environment
- Download a quantized embedding model (GGUF)
- Generate embeddings from input text using Llama.cpp

---

## Workflow

```mermaid
flowchart TD
    B[Install system packages: Python 3.12, gcc, cmake] --> C[Install uv - Python package manager]
    C --> D[Create Python virtual environment with uv]
    D --> E[Activate virtual environment]
    E --> F[Install llama-cpp-python from source]
    F --> G[Install huggingface-hub]
    G --> H[Download GGUF model to models directory]
    H --> I[Run Python code or open text-embedding.ipynb]
    I --> J[Generate text embeddings]
````

---

## System Requirements

* Red Hat Enterprise Linux 9+ or compatible (Rocky, Alma, CentOS Stream)
* Python 3.12 (plus `python3.12-devel`)
* Build tools: `gcc`, `cmake`, `make`, `libcurl-devel`
* At least 4–6 GB of system memory

---

## Install System Packages

If needed, enable CodeReady Builder:

```bash
sudo subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms
```

Then install required packages:

```bash
sudo dnf install -y python3.12 python3.12-devel gcc-c++ make cmake libcurl-devel wget
```

---

## Install `uv` (Python package manager)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv --version
```

---

## Set Up Python Environment

```bash
uv venv --python $(which python3.12)
source .venv/bin/activate
```

---

## Install Python Packages from Source

The following ensures `llama-cpp-python` builds using your local C++ toolchain (CMake, gcc):

```bash
uv pip install llama-cpp-python --no-binary :all:
uv pip install huggingface-hub
```

To set build flags manually, use:

```bash
export LLAMA_CPP_CMAKE_ARGS="-DLLAMA_NATIVE=ON"
```

---

## Download the GGUF Model

```bash
mkdir -p models
cd models

wget https://huggingface.co/phate334/multilingual-e5-large-gguf/resolve/main/multilingual-e5-large-q4_k_m.gguf

ls -lh multilingual-e5-large-q4_k_m.gguf
```

Model source: [Hugging Face – multilingual-e5-large-gguf](https://huggingface.co/phate334/multilingual-e5-large-gguf)

---

## Example: Generate Text Embeddings

See [`text-embedding.ipynb`](./text-embedding.ipynb) for a complete walkthrough.

```python
from llama_cpp import Llama

llm = Llama(
    model_path="models/multilingual-e5-large-q4_k_m.gguf",
    embedding=True,
    verbose=False
)

embedding = llm.create_embedding("Hello, world!")
vector = embedding['data'][0]['embedding']
print(vector)
```

---

## Notes

* This setup builds the `llama.cpp` C++ backend directly from source.
* The `.gguf` model used is optimized for text embedding tasks only.
* `uv` simplifies reproducible Python environments and speeds up installation.
* This guide assumes a CPU-only environment. No GPU or CUDA is required.

