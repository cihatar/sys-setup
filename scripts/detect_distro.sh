detect_distro() {
    . /etc/os-release
    if [ -z "$ID" ]; then
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
