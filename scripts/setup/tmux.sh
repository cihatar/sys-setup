conf=".tmux.conf"

install_packages ${pkgs}
install_config ${conf}
create_symlink "$df/${conf}" "$HOME/${conf}"

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    if git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &>/dev/null; then
        echo "tmux plugin manager installed"
    else
        echo -e "${red}tmux plugin manager not installed${nc}"
    fi
fi
