#!/bin/bash

df="$HOME/dotfiles"

vim_conf=".vimrc"
nvim_conf="init.lua"
tmux_conf=".tmux.conf"

vim=""
nvim=""
tmux=""

if [[ $# -eq 0 ]]; then
    vim="$vim_conf"
    nvim="$nvim_conf"
    tmux="$tmux_conf"
else
    for arg in "$@"; do
        case $arg in
            "vim") vim="$vim_conf";;
            "nvim") nvim="$nvim_conf";;
            "tmux") tmux="$tmux_conf";;  
            *) echo "entered wrong arguments"; exit 1;;
        esac
    done
fi

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

[[ -n "$vim" ]] && {
    install_config "$vim"  
    install_vim_plugin_manager  
    mkdir -p "$HOME/.vim/swapfiles"  
    create_link "$df/$vim" "$HOME/$vim"
}

[[ -n "$nvim" ]] && { 
    install_config "$nvim"  
    mkdir -p "$HOME/.config/nvim"  
    create_link "$df/$nvim" "$HOME/.config/nvim/$nvim"  
}

[[ -n "$tmux" ]] && { 
    install_config "$tmux"  
    install_tmux_plugin_manager 
    create_link "$df/$tmux" "$HOME/$tmux"
}

read -p "following packages will be installed (y/n)
   pyright
   bash-language-server 
   exuberant-ctags
   ripgrep
" confirm

if [[ ${confirm,} == "y" ]]; then
    if command -v npm &>/dev/null; then
        sudo npm install -g pyright bash-language-server
    else
        echo "npm not found"
    fi

    if ! dpkg -s exuberant-ctags >/dev/null 2>&1; then
        sudo apt install -y exuberant-ctags
    fi

    if ! dpkg -s ripgrep >/dev/null 2>&1; then
        sudo apt install -y ripgrep
    fi
fi

echo "done"
exit 0
