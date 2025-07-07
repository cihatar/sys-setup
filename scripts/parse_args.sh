print_help() {
    echo -e "${bold}usage:${nc} ./install.sh [options]"
    echo -e "${bold}options:${nc}"
    for pkg in "${!packages[@]}"; do
        printf "  ${green}%-20s${nc} > install %s\n" "$pkg" "$pkg"
    done
    printf "  ${green}%-20s${nc} > help\n" "-h, --help"
    printf "  ${green}%-20s${nc} > skip prompt\n" "-y, --yes"
}

parse_args() {
    if [[ $# -eq 0 ]] || 
        ([[ $# -eq 1 ]] && ([[ "$1" == "-y" ]] || [[ "$1" == "--yes" ]])); then
        set -- $@ ${!packages[@]}
    fi

    for arg in "$@"; do
        if [[ ${!packages[@]} =~ $arg ]]; then
            packages_to_install["$arg"]="${packages[$arg]}" 
        elif [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
            print_help
            exit 0
        elif [[ "$arg" == "-y" || "$arg" == "--yes" ]]; then
            yes_flag=true
        else
            echo -e "${red}invalid argument: '$arg'${nc}"
            exit 1
        fi
    done
}
