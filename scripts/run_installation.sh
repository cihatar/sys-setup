source "${dir}/scripts/install_packages.sh"

confirm() {
    if [ "$yes_flag" = false ]; then
        local packages_to_install_str=""
        for pkg in "${!packages_to_install[@]}"; do
            packages_to_install_str+="$pkg "
        done
        echo -e "\n${yellow}${packages_to_install_str}${nc}will be installed"
        read -p "continue? (y/n) " confirm
        [[ ${confirm,} != "y" ]] && exit 0
    fi 
}

run_installation() {
    confirm

    for package in "${!packages_to_install[@]}"; do
        local pkgs=${packages_to_install[$package]}

        installation_file="${dir}/scripts/setup/$package.sh"

        if [[ -f "$installation_file" ]]; then
            echo -e "\n${yellow}🛠️ installing $package${nc}" 

            source "$installation_file" && 
                echo -e "${green}$package installed${nc}" || 
                echo -e "${red}$package not installed${nc}"
        else
            echo -e "\n${red}$package installation file not found${nc}"
        fi
    done
}
