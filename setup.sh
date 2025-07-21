#!/bin/bash
#
# Automate the setup of zsh and plugins on a RHEL-based OS.

# --- Sanity Checks ---
# Ensure the script is run on a RHEL-based system
if ! command -v dnf &> /dev/null; then
    echo "[ERROR] This script requires 'dnf' and is intended for RHEL-based distributions. Exiting."
    exit 1
fi

# Ensure not running as root
if [[ $EUID -eq 0 ]]; then
   echo "[ERROR] This script must not be run as root. Use a regular user with sudo privileges. Exiting."
   exit 1
fi

# --- Configuration ---
ZSHRC_PATH="$HOME/.zshrc"

# Content for the .zshrc file
zshrc_content=$(cat <<- 'EOF'
# Set vim keybindings
bindkey -v

# Do not keep history duplicates
setopt histignorealldups sharehistory

# Keep 5000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

# General aliases
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'
EOF
)

# Content for zplug configuration
zplug_content=$(cat <<- 'EOF'

# Zplug - A next-generation plugin manager for zsh
# For more plugins, visit https://github.com/zplug/zplug
source ~/.zplug/init.zsh

# Uncomment the plugins you want to use
#zplug "plugins/git", from:oh-my-zsh
#zplug "plugins/sudo", from:oh-my-zsh
#zplug "plugins/command-not-found", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting"
#zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "romkatv/powerlevel10k, as:theme, depth:1"
#zplug "zsh-users/zsh-completions"
#zplug "junegunn/fzf"

# Key bindings for history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Install/load new plugins when zsh is started
if ! zplug check; then
    printf "Install missing zplug plugins? [y/N] "
    # Flush the input buffer to prevent previous key presses from being read
    while read -t 0.2 -n 1; do : ; done
    read -q REPLY
    echo
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        echo "Installing plugins..."
        zplug install
    fi
fi
zplug load
EOF
)

main() {
    echo "[INFO] Starting terminal setup for RHEL-based systems..."

    # Install dependencies
    echo "[INFO] Installing required packages: zsh, git, curl, unzip, util-linux-user..."
    sudo dnf install -y zsh git curl unzip util-linux-user
    echo "[SUCCESS] Dependencies installed."

    # Configure .zshrc
    echo "[INFO] Configuring ~/.zshrc..."
    if [ -f "$ZSHRC_PATH" ]; then
        echo "[INFO] ~/.zshrc already exists. Skipping creation."
        echo "To apply the new configuration, please remove or backup your existing '$ZSHRC_PATH' and re-run the script."
    else
        echo "$zshrc_content" > "$ZSHRC_PATH"
        echo "[SUCCESS] Created a default ~/.zshrc file."
    fi

    # Install zplug plugin manager
    echo "[INFO] Installing zplug..."
    if [ -d "$HOME/.zplug" ]; then
        echo "[INFO] ~/.zplug directory already exists. Skipping installation."
    else
        curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
        echo "[SUCCESS] zplug has been installed."
    fi

    # Add zplug configuration to .zshrc
    if grep -q "source ~/.zplug/init.zsh" "$ZSHRC_PATH"; then
        echo "[INFO] zplug is already configured in ~/.zshrc. Skipping."
    else
        echo "$zplug_content" >> "$ZSHRC_PATH"
        echo "[SUCCESS] Added zplug configuration to ~/.zshrc."
    fi

    # Change default shell to zsh
    echo "[INFO] Setting zsh as the default shell..."
    if [[ "$SHELL" == */zsh ]]; then
        echo "[INFO] zsh is already the default shell. Skipping."
    else
        if chsh -s "$(which zsh)" "$USER"; then
            echo "[SUCCESS] Default shell changed to zsh for user '$USER'."
            echo "[INFO] Please log out and log back in for the change to take effect."
        else
            echo "[ERROR] Failed to change the default shell. Please do it manually."
        fi
    fi

    echo
    echo "[SUCCESS] Terminal setup complete!"
    echo "Next steps:"
    echo "1. Log out and log back in to start using zsh."
    echo "2. When you first start zsh, it will ask to install plugins. Press 'y'."
    echo "3. The Powerlevel10k theme will start its configuration wizard. Follow the on-screen instructions."
    echo "   For the best experience, it is recommended to use a 'Nerd Font' in your terminal emulator."
}

main "$@"