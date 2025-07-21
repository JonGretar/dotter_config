# Dotfiles with Dotter

This repository contains my personal configuration files (dotfiles) managed with [Dotter](https://github.com/SuperCuber/dotter). Dotter is a dotfile manager and templating engine that helps to organize, version control, and deploy configuration files across different machines.

## What is Dotter?

Dotter is a dotfile manager written in Rust that uses the [Handlebars](https://handlebarsjs.com/) templating engine. It allows you to:

1. Organize your configuration files in a single repository
2. Use templates with variables for different environments
3. Easily deploy your dotfiles to the correct locations
4. Maintain machine-specific configurations separately from shared ones

## Repository Structure

This repository contains configurations for the following tools:

- **zsh**: Shell configuration
- **git**: Global git configuration and ignore patterns
- **starship**: Cross-shell prompt configuration
- **bat**: A `cat` clone with syntax highlighting
- **radian**: A console for R with syntax highlighting
- **zed**: Configuration for the Zed editor
- **harlequin**: SQL client configuration
- **fastfetch**: System information display tool
- **ov**: Terminal pager configuration

## Setup

Basics to set up a new computer. Not all of this is related to Dotter config
files but where else should I store this info.

### Brew Packages

Require for the shell as configured:

```sh
brew install bat carapace direnv dotter eva eza fastfetch fd jq ov procs \
starship zsh-autopair zsh-autosuggestions zsh-vi-mode
```

Dev Related:

```sh
brew install asdf cmake curl duckdb fop git-lfs hexyl jj just lazydocker \
 lazygit miniserve neovim nushell pandoc sqlite typst
```

Shell Apps:

```sh
brew install aerc btop diskonaut duf dust ripgrep ripgrep-all television \
 yazi zoxide
```

Casks:

- discord
- docker-desktop
- wezterm@nightly
- font-fira-code-nerd-font
- font-fira-mono-nerd-font
- font-monaspace
- ghostty
- git-credential-manager
- google-chrome
- homerow
- quarto
- raycast
- sioyek
- skim
- xquartz

### Wezterm Terminfo

Install the wezterm terminfo.

```sh
tempfile=$(mktemp) \
  && curl -o $tempfile https://raw.githubusercontent.com/wezterm/wezterm/main/termwiz/data/wezterm.terminfo \
  && tic -x -o ~/.terminfo $tempfile \
  && rm $tempfile

```

### ASDF
