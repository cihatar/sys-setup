# Automated System Setup

This repo contains an installation script to quickly set up development environment on a fresh Linux machine.

**Usage**

```bash
$ ./install.sh [options]
```

**Example**

```bash
$ ./install.sh vim tmux
```

**Flags**

```bash
-h, --help   show usage help
-y, --yes    skip prompt
```

## What it does

- Detects your Linux distro and selects the right package manager
- Installs required packages
- Sets up config, plugin manager, etc. 

---

## Add a new installation script

- Add your package information to the `packages.txt` using the format: `<your-package-name>=<required-package-1> <required-package-2> ...`
- Create a bash script named after your package in the `/scripts/setup` directory
- Inside the script, use `install_packages` function to install the required packages and write your installation or configuration logic
- Run with `./install.sh <your-package-name>`

---

## Add environment variables

- Create .env file in the root directory
- Define your variables using the format: `KEY=value`
- Access them in any custom setup script using `$KEY`

---

**Note**: This project is personal and includes custom configuration. Use at your own risk.
