print_help() {
    echo -e "${bold}usage${nc} ./install.sh [options]"
    echo -e "${bold}options:${nc}"
    echo -e "  ${green}vim${nc}         > install vim"
    echo -e "  ${green}nvim${nc}        > install neovim"
    echo -e "  ${green}tmux${nc}        > install tmux"
    echo -e "  ${green}-h, --help${nc}  > help"
    echo -e "  ${green}-y, --yes${nc}   > skip prompt"
}

parse_args() {
    if [ $# -eq 0 ] || { 
        [ $# -eq 1 ] && { [[ "$1" == "-y" ]] || [[ "$1" == "--yes" ]]; }; 
    }; then
        set -- $@ "vim" "nvim" "tmux"
    fi

    for arg in "$@"; do
        case "$arg" in
            vim|nvim|tmux)
                add_packages "$arg"
                ;;
            -h|--help)
                print_help
                exit 0
                ;;
            -y|--yes)
                yes_flag=true
                ;;
            *) 
                echo -e "${red}invalid argument: '$arg'${nc}" 
                exit 1
                ;;
        esac
    done
}
