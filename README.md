# llama.cpp-project
# llama.cpp-project

# RHEL
sudo dnf install python3.12 cmake gcc-c++ make libcurl-devel
sudo dnf install python3.12-devel     # RHEL
curl -LsSf https://astral.sh/uv/install.sh | sh
uv --version

uv venv --python $(which python3.12)
source .venv/bin/activate

uv pip install llama-cpp-python --no-binary :all:


curl -LsSf https://astral.sh/uv/install.sh | sh


