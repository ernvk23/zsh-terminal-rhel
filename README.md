# Terminal setup

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This script helps you set up a modern terminal environment on a RHEL-based OS (like Fedora, CentOS, AlmaLinux, or Rocky Linux). It installs Zsh, the `zplug` plugin manager, and a few useful plugins to improve your command-line experience.

## Features

- **Zsh Shell**: Installs Zsh and sets it as the default shell.
- **zplug Plugin Manager**: Uses `zplug` for easy plugin management.
- **Powerlevel10k Theme**: Installs the popular Powerlevel10k theme for a better-looking prompt.
- **Essential Plugins**:
  - `zsh-syntax-highlighting`: Adds color to the commands you type.
  - `zsh-history-substring-search`: Lets you search your command history easily.
- **Sensible Defaults**: Creates a `.zshrc` file with useful aliases and settings.
- **Safe & Simple**: Includes safety checks and is safe to run multiple times.

## Installation

### Prerequisites
- A RHEL-based Linux distribution.
- `curl` to download the script.
- `sudo` privileges for the running user.

### Quick start
1. Run this command on your terminal:
  ```bash
  curl -O https://raw.githubusercontent.com/ernvk23/zsh-terminal-rhel/main/setup.sh && chmod +x ./setup.sh && sudo ./setup.sh
  ```

### Tested Distributions
- AlmaLinux 9.6

### Disclaimer
Always review scripts before running them on your system. While this script aims to automate the setup process, it's essential to understand what it does and ensure it aligns with your requirements and expectations.

### License
This project is licensed under the [MIT License](LICENSE.md).