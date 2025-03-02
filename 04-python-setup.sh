#!/bin/bash
set -e

echo "Setting up Python environment with Conda..."

# Install Miniconda (smaller footprint than Anaconda)
brew install --cask miniconda

# Initialize Conda for shell integration
CONDA_PATH="$(brew --prefix)/Caskroom/miniconda/base"
"$CONDA_PATH/bin/conda" init zsh

# Create separate environments for different workflows
#echo "Creating Python environments..."

# Environment for Django development
#"$CONDA_PATH/bin/conda" create -y -n django python=3.12 django
#echo "Created Django environment. Activate with: conda activate django"

# Environment for MLX and LLMs
#"$CONDA_PATH/bin/conda" create -y -n ml python=3.12
#"$CONDA_PATH/bin/conda" activate ml
#"$CONDA_PATH/bin/conda" install -y -c conda-forge pip

# Install MLX (Apple's ML framework)
#echo "Installing MLX framework in ML environment..."
#"$CONDA_PATH/bin/pip" install mlx

# Install common ML packages
#"$CONDA_PATH/bin/pip" install numpy pandas matplotlib jupyter

#echo "Created ML environment. Activate with: conda activate ml"

# Add Conda configuration to conda.sh
cat > ~/code/scripts/conda.sh << 'EOF'
#!/bin/bash

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
EOF

echo "Python environment setup with Conda complete!"

