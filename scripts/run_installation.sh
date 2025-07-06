source "${dir}/scripts/install_packages.sh"
source "${dir}/scripts/install_config.sh"

confirm() {
    echo "the following packages will be installed"
    for key in "${!pkgs_dict[@]}"; do
        for pkgs in ${pkgs_dict[$key]}; do
            echo -e "${yellow}${pkgs}${nc}"
        done
    done
    read -p "continue? (y/n) " confirm
    [[ ${confirm,} != "y" ]] && exit 0
}

run_installation() {
    confirm

    for key in "${!pkgs_dict[@]}"; do
        echo -e "\n${yellow}🛠️ installing $key${nc}" && 
        pkgs=${pkgs_dict[$key]}

        case "$key" in
            vim) source "${dir}/scripts/setup/vim.sh";;
            nvim) source "${dir}/scripts/setup/nvim.sh";; 
            tmux) source "${dir}/scripts/setup/tmux.sh";;
        esac
        echo -e "${green}${key} installed${nc}" 
    done
}
