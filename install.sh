#!/bin/bash

nc='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
bold='\033[1m'

df="$HOME/dotfiles"

distro=""
pkg_mgr=""

declare -A pkgs=()

show_help() {
    echo -e "${bold}usage${nc} ./install.sh [options]"
    echo -e "${bold}options:${nc}"
    echo -e "  ${green}vim${nc}         > install vim"
    echo -e "  ${green}nvim${nc}        > install neovim"
    echo -e "  ${green}tmux${nc}        > install tmux"
    echo -e "  ${green}-h, --help${nc}  > help"
    exit 0
}

args_checker() {
    if [ $# -eq 0 ]; then
        echo -e "${yellow}missing arguments, use --help flag${nc}"
        exit 1
    fi

    for arg in "$@"; do
        case "$arg" in
            -h|--help) show_help; exit 0;;
            vim) pkgs["vim"]="vim universal-ctags ripgrep";;
            nvim) pkgs["nvim"]="npm";;
            tmux) pkgs["tmux"]="tmux";;
            *) echo -e "${red}invalid argument: '$arg'${nc}"; exit 1;;
        esac
    done
}

confirm() {
    echo "the followings will be installed"
    for key in "${!pkgs[@]}"; do
        for pkg in ${pkgs[$key]}; do
            echo -e "${yellow}${pkg}${nc}"
        done
    done
    read -p "continue? (y/n) " confirm
    [[ ${confirm,} != "y" ]] && exit 0
}

detect_distro() {
    . /etc/os-release
    if [ -z $ID ]; then
        echo -e "${red}unsupported distribution${nc}"
        exit 1
    else
        distro=$ID
        echo -e "${green}$distro detected${nc}\n"
    fi

    case "$distro" in
        ubuntu|debian) pkg_mgr="apt";;
        fedora) pkg_mgr="dnf";;
        centos|rhel) pkg_mgr="yum";;
        arch) pkg_mgr="pacman";;
        alpine) pkg_mgr="apk";;
        *) echo -e "${red}unsupported distribution${nc}"; exit 1;;
    esac
}

install_config() {
    local file="$1"
    if [ -f "./$file" ]; then
        cp "./$file" "$df/$file" &>/dev/null 
        echo "copied $file into $df"
    else
        echo "$file not found. pulling from github..."
        if ! curl -o "$df/$file" https://raw.githubusercontent.com/cihatar/sys-setup/main/$file &>/dev/null; then
            echo -e "${red}failed to download $file${nc}"
            exit 1
        fi        
    fi
}

create_link() {
    local src="$1"
    local dest="$2"
    sudo ln -sf "$src" "$dest" &>/dev/null
    echo "symbolic link created ($dest -> $src)"
}

install_packages() {
    for pkg in "$@"; do
        case "$pkg_mgr" in
            apt)
                if sudo apt-get install -y "$pkg" >/dev/null 2>&1; then
                    echo "installed package $pkg successfully"
                else
                    echo -e "${red}failed to install $pkg${nc}"
                fi
                ;;
            dnf|yum)
                if sudo "$pkg_mgr" install -y "$pkg" >/dev/null 2>&1; then
                    echo "installed package $pkg successfully"
                else
                    echo -e "${red}failed to install $pkg${nc}"
                fi
                ;;
            pacman)
                if sudo pacman -S --noconfirm "$pkg" >/dev/null 2>&1; then
                    echo "installed package $pkg successfully"
                else
                    echo -e "${red}failed to install $pkg${nc}"
                fi
                ;;
            apk)
                if sudo apk add --no-cache "$pkg" >/dev/null 2>&1; then
                    echo "installed package $pkg successfully"
                else
                    echo -e "${red}failed to install $pkg${nc}"
                fi
                ;;
        esac
    done
}

install() {
    for key in "${!pkgs[@]}"; do
        echo -e "\n${yellow}🛠️ installing $key${nc}" && 
        install_packages ${pkgs[$key]}

        case "$key" in
            vim)
                conf=".vimrc"
                install_config ${conf}
                mkdir -p "$HOME/.vim/swapfiles"  
                create_link "$df/${conf}" "$HOME/${conf}"
                if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
                    if curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &>/dev/null; then
                        echo "vim plugin manager installed"
                    else
                        echo -e "${red}vim plugin manager not installed${nc}"
                    fi
                fi
                ;;

            nvim)
                conf="init.lua"
                if ! curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz &>/dev/null; then
                    echo -e "${red}failed to download $file${nc}"
                    exit 1
                fi        
                sudo rm -rf /opt/nvim
                sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
                create_link "/opt/nvim-linux-x86_64/bin/nvim" "/usr/local/bin/nvim" 
                rm nvim-linux-x86_64.tar.gz
                install_config ${conf}
                mkdir -p "$HOME/.config/nvim"  
                create_link "$df/${conf}" "$HOME/.config/nvim/${conf}"
                ;; 

            tmux)
                conf=".tmux.conf"
                install_config ${conf}
                create_link "$df/${conf}" "$HOME/${conf}"
                if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
                    if git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &>/dev/null; then
                        echo "tmux plugin manager installed"
                    else
                        echo -e "${red}tmux plugin manager not installed${nc}"
                    fi
                fi
                ;;
        esac
        echo -e "${green}${key} installed${nc}" 
    done
}

done_ascii() {
    echo -e "
    ⠀⠀⠀⠀⠀⠀⢀⣠⣤⣄⣤⣶⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⣀⣴⠟⣉⣙⣟⣛⢻⡟⠿⢿⣷⠀⠀⠀⠀⢰⣃⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⢀⣾⡟⠛⠛⠻⠿⠿⠿⣿⣿⠷⠦⠘⣧⠀⢀⠄⡶⠁⠀⠀⠀⠀⠀ ${green}${bold}done champ${nc}
    ⠀⢀⣾⣿⣧⣶⣿⣤⠀⠀⣴⣹⠏⠀⠀⠀⠿⣧⢈⣞⣀⡤⠚⢿⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⢸⣿⣿⣿⣿⣿⣿⣿⣶⠻⣿⣿⠷⠟⠃⣿⣏⠀⠀⠀⠀⢀⣼⣤⣿⣾⡍⠲⣤⡀⠀
    ⠀⠈⢻⣿⣿⣿⣿⡿⢿⣿⢿⣿⡇⠀⠀⡿⢟⡉⠑⡄⠀⠀⠀⠉⢩⣽⡷⣿⣿⣯⣹⣆
    ⠀⠀⠀⢻⣿⣿⣿⠷⢻⢿⠀⠀⠀⠀⠀⡀⠙⣷⡎⠁⠀⠀⠀⠀⠈⢙⡇⣿⣿⣹⢁⡿
    ⠀⠀⠀⠈⡿⠟⠙⠢⣟⠟⠀⠀⠀⠀⠈⠴⣿⣿⠁⠀⠀⠀⠀⠀⠾⢿⢁⣼⠛⠳⣀⡇
    ⠀⠀⣀⣼⣷⣦⣄⡀⠈⢻⣷⣄⣀⣠⣴⣾⡋⣈⡆⠀⠀⠀⠀⠀⢠⡇⠀⠹⡇⣴⠟⠑
    ⢰⣿⣿⣿⣿⣿⣿⣿⣶⣤⡀⠉⢿⣿⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⣿⡇⠀⢠⡿⠋⠀⠀
    ⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣬⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⢿⡇⠀⠀⠀
    ⠀⠙⠿⣿⡛⠿⢿⢉⣻⣿⣿⣿⣿⣿⣿⣿⣷⣆⠀⠀⠀⠀⠀⢰⡟⠉⠉⠛⢧⣀⠀⠀
    ⠀⠀⠀⠙⠻⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⢹⣿⣿⣿⣿⣶⣤⣽⣄
    ⠀⠀⠀⠀⠀⠙⢿⣿⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿
    ⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⢹⣿⣿⣿⣽⣿⣿⣿⡇
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣟⣛⡛⣿⣿⣿⡇
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠟⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⠿⠿⣿⠿⠟⠋⠀⠀⠀
    "
}

args_checker "$@"
detect_distro
confirm 
mkdir -p "$df"  
install
done_ascii

exit 0 
