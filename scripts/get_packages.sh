get_packages() {
    local path="${dir}/packages.txt"

    if [[ ! -f "$path" ]]; then
        echo -e "${red}packages file not found${nc}"
        exit 1
    fi

    while IFS="=" read -r key value; do
        [[ -z "$key" ]] && continue
        
        key="$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
        value="$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

        packages["$key"]="$value"
    done < "$path" 
}
