source "${dir}/scripts/install_packages.sh"
source "${dir}/scripts/install_config.sh"

confirm() {
    if [ "$yes_flag" = false ]; then
        local pkgs_str=""
        for pkg in "${!pkgs_dict[@]}"; do
            pkgs_str+="$pkg "
        done
        echo -e "\n${yellow}${pkgs_str}${nc}will be installed"
        read -p "continue? (y/n) " confirm
        [[ ${confirm,} != "y" ]] && exit 0
    fi 
}

run_installation() {
    confirm

    for key in "${!pkgs_dict[@]}"; do
        echo -e "\n${yellow}🛠️ installing $key${nc}" && 
        local pkgs=${pkgs_dict[$key]}

        case "$key" in
            vim) source "${dir}/scripts/setup/vim.sh";;
            nvim) source "${dir}/scripts/setup/nvim.sh";; 
            tmux) source "${dir}/scripts/setup/tmux.sh";;
        esac
        echo -e "${green}${key} installed${nc}" 
    done
}
