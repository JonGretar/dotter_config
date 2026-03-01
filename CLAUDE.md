# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles managed with [Dotter](https://github.com/SuperCuber/dotter) — a Rust dotfile manager using Handlebars templating. Files are either symlinked or copied to their target locations on deploy.

## Dotter commands

```sh
dotter deploy        # Deploy all active packages to their targets
dotter deploy -d     # Dry run — show what would happen without doing it
dotter undeploy      # Remove deployed files/symlinks
dotter watch         # Watch for changes and auto-redeploy
```

## How packages work

- **`.dotter/global.toml`** — defines all packages and their file mappings (repo path → filesystem target)
- **`.dotter/local.toml`** — lists which packages are active on this machine; overrides targets/variables defined in `global.toml`
- Packages can declare `depends = ["other_package"]` to pull in shared variable sets (e.g. a `theme` package)

**Symlinks vs templates:** Files containing `{{` are automatically treated as templates (rendered and copied). All others are symlinked. Override with `type = "symbolic"` or `type = "template"` in a complex target entry. **Templated files do not auto-update on edit** — run `dotter deploy` or `dotter watch` after changes.

**Templating features available in templates:**
- `{{variable}}` — variable substitution from `[package.variables]`
- `{{dotter.macos}}`, `{{dotter.linux}}` — platform booleans
- `{{dotter.packages.pkgname}}` — check if a package is enabled
- `{{#if (is_executable "cmd")}}` — check if a command exists
- `{{command_output "cmd"}}` — inline shell output
- `{{math font_size "*" 2}}` — arithmetic

**Complex target syntax** (override detection, add owner, conditional deploy):
```toml
[pkg.files.source_file]
target = "~/.config/foo"
type = "symbolic"          # or "template"
if = "(eq dotter.macos true)"   # conditional
append = "extra text"      # template only
```

**Hooks** — place executable scripts at `.dotter/pre_deploy.sh`, `.dotter/post_deploy.sh`, etc. They are rendered as templates before execution.

Adding a new tool:
1. Create a directory in the repo root for the tool's config files
2. Add a `[toolname.files]` section in `.dotter/global.toml` mapping repo paths to targets
3. Add `"toolname"` to the `packages` list in `.dotter/local.toml`

**`local.toml` overrides** — file targets and variables in `local.toml` always win over `global.toml`. Set a file target to `""` to disable it on this machine. Use `includes = [".dotter/macos.toml"]` for shared per-OS overrides.

## Version control

This repo uses **jj (Jujutsu)** as the primary VCS, with git as the backend. The `main` branch is the primary branch.

Key jj aliases defined in `jj/config.toml`:
- `jj tug` — moves the nearest bookmark to the nearest pushable commit
- `jj push` — runs pre-push checks via `uvx jj-pre-push push`
- `jj ui` — opens jjui TUI

Commits prefixed `wip:` or `private:` are blacklisted and blocked from being pushed.

## Yazi plugins

Yazi plugins are pinned by revision hash in `yazi/package.toml`. To update plugins, edit the `rev` and `hash` fields there, then run `ya pack` inside yazi or `yazi --clear-cache`.
