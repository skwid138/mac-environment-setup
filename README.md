# macOS Developer Environment Setup

A collection of shell scripts to automate the setup of a macOS development environment and remove unnecessary preinstalled applications.

## Features

- **Modular Design**: Each script focuses on a specific task and can be run independently
- **Interactive Workflow**: Scripts prompt before making changes
- **Development Environment Setup**:
  - Custom script environment with useful aliases and functions
  - Core development tools (VS Code, Cursor IDE, Ghostty terminal)
  - Node.js (via NVM) with LTS version
  - Python (via Miniconda)
  - Docker
  - ZSH customization with Zplug and Spaceship prompt
  - Common applications (Firefox, Chrome, Slack, Discord)
- **Application Removal**:
  - Safe removal of GarageBand, iMovie, and iWork suite
  - System cache cleanup
  - Disk space recovery

## Prerequisites

- macOS (Tested on macOS Sequoia 15.3.1 on an M4 Max MacBook Pro)
- Administrator privileges
- Internet connection

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/skwid138/mac-environment-setup.git
   cd mac-environment-setup
   ```

2. Make the main scripts executable:
   ```bash
   chmod +x install.sh
   chmod +x remove.sh
   ```

3. Run the installation script:
   ```bash
   ./install.sh
   ```

## Usage

### Development Environment Setup

The `install.sh` script will guide you through the installation process, with prompts before executing each section:

1. **Script Environment**: Sets up a custom script environment with useful utilities
2. **Base Setup**: Installs Homebrew and CLI utilities (fortune, cowsay, lolcat, tmux)
3. **Development Tools**: Installs VS Code, Cursor IDE, Ghostty terminal, and other tools
4. **Node.js Environment**: Sets up NVM and installs the latest LTS version of Node.js
5. **Python Environment**: Installs Miniconda for Python development
6. **Docker**: Installs Docker Desktop
7. **ZSH Customization**: Sets up Zplug with Spaceship prompt and useful plugins
8. **Common Applications**: Installs Firefox, Chrome, Slack, and Discord

Each section can be installed independently by running the corresponding script directly:

```bash
./00-script-environment.sh
./01-base-setup.sh
./02-dev-tools.sh
./03-node-setup.sh
./04-python-setup.sh
./05-docker-setup.sh
./06-zsh-customization.sh
./07-common-apps.sh
```

### Application Removal

The `remove.sh` script helps you remove preinstalled macOS applications and clean up system caches:

1. **GarageBand**: Removes GarageBand and associated sound libraries
2. **iWork Suite**: Removes Pages, Numbers, and Keynote
3. **iMovie**: Removes iMovie and associated files
4. **System Cache Cleanup**: Clears various system caches to free up disk space

Run the removal script:
```bash
./remove.sh
```

## Script Details

### Installation Scripts

- **00-script-environment.sh**: Creates a modular script environment with separate files for variables, paths, aliases, and functions. Downloads custom scripts from GitHub gists.
- **01-base-setup.sh**: Installs Homebrew and essential CLI utilities.
- **02-dev-tools.sh**: Installs development tools including VS Code, Cursor IDE, Ghostty terminal, GitHub CLI, and Google Cloud SDK.
- **03-node-setup.sh**: Sets up Node.js using NVM and installs essential global npm packages.
- **04-python-setup.sh**: Installs Miniconda and configures the environment for Python development.
- **05-docker-setup.sh**: Installs Docker Desktop.
- **06-zsh-customization.sh**: Installs and configures Zplug with plugins for ZSH enhancement.
- **07-common-apps.sh**: Installs commonly used applications like Firefox, Chrome, Slack, and Discord.

### Removal Scripts

- **remove_garageband.sh**: Safely removes GarageBand and its associated components.
- **remove_imovie.sh**: Removes iMovie and its associated files.
- **remove_iwork_suite.sh**: Removes Pages, Numbers, and Keynote along with their container files.
- **remove_other_apps.sh**: Provides options to remove other preinstalled applications.
- **clear_system_cache.sh**: Cleans system caches to free up disk space.

## Customization

### Script Environment

The script environment creates the following structure in `~/code/scripts/`:

- **init.sh**: Main script that sources all other scripts
- **vars.sh**: Environment variables
- **paths.sh**: PATH additions
- **aliases.sh**: Command aliases
- **functions.sh**: Utility functions
- **cowsay_fortune_lolcat.sh**: Fun terminal additions
- **Tool-specific configs**: For NVM, Conda, GCloud, etc.

You can modify these files to customize your environment.

### Terminal Setup

The scripts install and configure Ghostty terminal with Zplug and Spaceship prompt for an enhanced terminal experience. You can customize the configuration by modifying:

- **~/.ghostty/**: Ghostty terminal configuration
- **~/code/scripts/zsh_plugins.sh**: ZSH plugins configuration

## Future Enhancements

- Additional application installation options (e.g., productivity apps, media tools)
- System preference configurations
- Git configuration setup

## License

[MIT License](LICENSE)

## Acknowledgments

- [Homebrew](https://brew.sh/)
- [NVM](https://github.com/nvm-sh/nvm)
- [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
- [Docker](https://www.docker.com/)
- [Zplug](https://github.com/zplug/zplug)
- [Spaceship Prompt](https://github.com/spaceship-prompt/spaceship-prompt)
- [Ghostty Terminal](https://ghostty.com/)
