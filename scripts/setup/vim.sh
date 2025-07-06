conf=".vimrc"

install_packages ${pkgs}
install_config ${conf}
mkdir -p "$HOME/.vim/swapfiles"  
create_symlink "$df/${conf}" "$HOME/${conf}"

if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    if curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &>/dev/null; then
        echo "vim plugin manager installed"
    else
        echo -e "${red}vim plugin manager not installed${nc}"
    fi
fi
