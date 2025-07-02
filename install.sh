#!/bin/bash

df="$HOME/dotfiles"

vim=".vimrc"
nvim="init.lua"
tmux=".tmux.conf"

install_config() {
    local file="$1"
    if [ -f "./$file" ]; then
        cp -v "./$file" "$df/$file" 
    else
        echo "pulling $file from github..."
        if ! curl -o "$df/$file" https://raw.githubusercontent.com/cihatar/dotfiles/main/$file &>/dev/null; then
            echo "failed to download $file"
            exit 1
        fi        
    fi
}

create_link() {
    local src="$1"
    local dest="$2"
    rm -f -v "$dest" 
    ln -s -v "$src" "$dest"
}

install_vim_plugin_manager() {
    if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &>/dev/null
    fi
}

install_tmux_plugin_manager() {
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 
    fi
}

if [ ! -d "$df" ]; then
    mkdir -p "$df" 
fi

install_config "$vim"
install_config "$nvim"
install_config "$tmux"

mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.vim/swapfiles"

install_vim_plugin_manager
install_tmux_plugin_manager

create_link "$df/$vim" "$HOME/$vim"
create_link "$df/$nvim" "$HOME/.config/nvim/$nvim"
create_link "$df/$tmux" "$HOME/$tmux"

if command -v npm &>/dev/null; then
    echo "installing npm packages..."
    sudo npm install -g pyright bash-language-server &>/dev/null
fi

echo "installing exuberant-ctags..."
if ! dpkg -s exuberant-ctags >/dev/null 2>&1; then
    sudo apt install -y exuberant-ctags
fi

echo "done"
exit 0
