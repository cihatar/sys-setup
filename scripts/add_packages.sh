add_packages() {
    local pkg="$1"
    case "$pkg" in
        vim)
            pkgs_dict["vim"]="vim universal-ctags ripgrep"
            ;;
        nvim)
            pkgs_dict["nvim"]="npm"
            ;;
        tmux)
            pkgs_dict["tmux"]="tmux"
            ;;
    esac
}
