install_packages() {
    for pkg in $pkgs; do
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
