#!/bin/bash

nc='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
bold='\033[1m'

distro=""
pkg_mgr=""
yes_flag=false

declare -A packages
declare -A packages_to_install

dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

[ -f "${dir}/.env" ] && source "${dir}/.env"
source "${dir}/scripts/get_packages.sh"
source "${dir}/scripts/parse_args.sh"
source "${dir}/scripts/detect_distro.sh"
source "${dir}/scripts/run_installation.sh"
source "${dir}/scripts/ascii.sh"

get_packages
parse_args "$@"
detect_distro 
run_installation
ascii
