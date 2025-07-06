conf="init.lua"

install_packages ${pkgs}

if ! curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz &>/dev/null; then
    echo -e "${red}failed to download $file${nc}"
    exit 1
fi        

sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
create_symlink "/opt/nvim-linux-x86_64/bin/nvim" "/usr/local/bin/nvim" 
rm nvim-linux-x86_64.tar.gz

install_config ${conf}
mkdir -p "$HOME/.config/nvim"  

create_symlink "$df/${conf}" "$HOME/.config/nvim/${conf}"
