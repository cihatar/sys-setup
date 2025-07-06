print_help() {
    echo -e "${bold}usage${nc} ./install.sh [options]"
    echo -e "${bold}options:${nc}"
    echo -e "  ${green}vim${nc}         > install vim"
    echo -e "  ${green}nvim${nc}        > install neovim"
    echo -e "  ${green}tmux${nc}        > install tmux"
    echo -e "  ${green}-h, --help${nc}  > help"
}

parse_args() {
    if [ $# -eq 0 ]; then
        echo -e "${yellow}missing arguments, use --help flag${nc}"
        exit 1
    fi

    for arg in "$@"; do
        case "$arg" in
            -h|--help)
                print_help
                exit 0
                ;;
            vim|nvim|tmux)
                add_packages "$arg"
                ;;
            *) 
                echo -e "${red}invalid argument: '$arg'${nc}" 
                exit 1
                ;;
        esac
    done
}
