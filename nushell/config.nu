# config.nu
#
# Installed by:
# version = "0.106.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R


$env.config.datetime_format.normal = "%y-%m-%d %H:%M:%S"

# source $"($nu.home-path)/.cargo/env.nu"

# VI mode stuff
$env.config.edit_mode = 'vi'
$env.config.cursor_shape.vi_insert = "line"
$env.config.cursor_shape.vi_normal = "block"
$env.PROMPT_INDICATOR_VI_NORMAL = "[N] "
$env.PROMPT_INDICATOR_VI_INSERT = "[I] "


source "lib/zoxide.nu"
source ~/.cache/carapace/init.nu

alias cd = z
alias l = eza --icons=auto
