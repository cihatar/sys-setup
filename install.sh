#!/bin/bash

df="$HOME/dotfiles"

nvim="init.lua"
tmux=".tmux.conf"

install_config() {
    local file="$1"
    if [ -f "./$file" ]; then
        cp -v "./$file" "$df/$file" 2>/dev/null
    else
        echo "pulling $file from github..."
        curl -o "$df/$file" https://raw.githubusercontent.com/cihatar/dotfiles/main/$file &>/dev/null 
    fi
}

create_link() {
    local src="$1"
    local dest="$2"
    rm -f -v "$dest" 
    ln -s -v "$src" "$dest"
}

install_tmux_plugin_manager() {
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 
    fi
}

if [ ! -d "$df" ]; then
    mkdir -p "$df" 
fi

install_config "$nvim"
install_config "$tmux"

mkdir -p "$HOME/.config/nvim"
install_tmux_plugin_manager

create_link "$df/$nvim" "$HOME/.config/nvim/$nvim"
create_link "$df/$tmux" "$HOME/$tmux"

if command -v npm &>/dev/null; then
    echo "installing npm packages..."
    sudo npm install -g pyright bash-language-server &>/dev/null
fi

echo "done"
exit 0
