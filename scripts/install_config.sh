install_config() {
    local file="$1"
    mkdir -p "$df"  

    if [ -f "./configs/$file" ]; then
        cp "./configs/$file" "$df/$file" &>/dev/null 
        echo "copied $file into $df"
    else
        echo "$file not found. pulling from github..."
        if ! curl -o "$df/$file" https://raw.githubusercontent.com/cihatar/sys-setup/main/$file &>/dev/null; then
            echo -e "${red}failed to download $file${nc}"
            exit 1
        fi        
    fi
}

create_symlink() {
    local src="$1"
    local dest="$2"
    sudo ln -sf "$src" "$dest" &>/dev/null
    echo "symbolic link created ($dest -> $src)"
}
