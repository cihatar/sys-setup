#!/bin/bash

nc='\033[0m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
bold='\033[1m'

df="$HOME/dotfiles"

distro=""
pkg_mgr=""

declare -A pkgs_dict=()

source "./scripts/parse_args.sh"
source "./scripts/add_packages.sh"
source "./scripts/detect_distro.sh"
source "./scripts/run_installation.sh"
source "./scripts/ascii.sh"

parse_args "$@"
add_packages 
detect_distro 
run_installation
ascii
