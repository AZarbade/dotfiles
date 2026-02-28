# Dotfiles

My Personal dotfiles. Configs are organized under the `avalore/` directory and are meant to be symlinked or copied into `$HOME`.

## Structure

```
dotfiles/
├── .gitconfig               # Global git configuration
├── .gitignore
├── .gitmodules              # Submodule: tmux plugin manager (tpm)
└── avalore/
    ├── .bashrc              # Bash shell config (Linux)
    ├── .zshrc               # Zsh shell config (macOS)
    └── .config/
        ├── nvim/
        │   └── init.lua     # Neovim configuration
        ├── tmux/
        │   └── tmux.conf    # Tmux configuration
        └── ghostty/
            └── config       # Ghostty terminal configuration
```

## Tools

| Tool | Purpose |
|------|---------|
| [Neovim](https://neovim.io/) | Primary editor |
| [Tmux](https://github.com/tmux/tmux) | Terminal multiplexer |
| [Ghostty](https://ghostty.org/) | Terminal emulator |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [eza](https://github.com/eza-community/eza) | Modern `ls` replacement (zsh) |

---

## Neovim (`avalore/.config/nvim/init.lua`)

A minimal, plugin-light Neovim setup using Neovim's built-in `vim.pack` for plugin management and native LSP for language intelligence.

### Plugins

- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** — LSP server configurations
- **[oil.nvim](https://github.com/stevearc/oil.nvim)** — File explorer as a buffer

### LSP Servers

- `rust_analyzer` (with Clippy and all features enabled)
- `ruff` (Python linter/formatter)
- `clangd` (C/C++)
- `lua_ls` (Lua)

### Key Bindings

| Key | Action |
|-----|--------|
| `<Space>` | Leader key |
| `<left>` / `<right>` | Previous / next buffer |
| `<leader>y` | Yank to system clipboard |
| `Q` | Close current buffer |
| `<leader><leader>` | Switch to previous buffer |
| `<C-h/j/k/l>` | Navigate between panes |
| `<C-s>` | Search and replace word under cursor |
| `<C-p>` | fzf file picker |
| `<leader>f` | Format file via LSP |
| `-` | Open parent directory (oil.nvim) |
| `K` | Hover documentation (LSP) |
| `<leader>e` | Open diagnostics float |

### Notable Settings

- `retrobox` colorscheme with transparent background
- Relative line numbers
- Tabs (not spaces), width 4
- Infinite undo history (`~/.local/state/nvim/undo/`)
- Smart case search
- Histogram diff algorithm

---

## Tmux (`avalore/.config/tmux/tmux.conf`)

### Prefix

`Ctrl-a` (replaces default `Ctrl-b`)

### Key Bindings

| Key | Action |
|-----|--------|
| `prefix + \|` | Split pane horizontally (cwd-aware) |
| `prefix + _` | Split pane vertically (cwd-aware) |
| `prefix + h/j/k/l` | Navigate panes (vim-style) |
| `prefix + p` / `n` | Previous / next window |
| `prefix + r` | Reload tmux config |
| `v` (copy mode) | Begin selection |
| `y` (copy mode) | Copy to clipboard (`pbcopy`) |

### Settings

- Windows indexed from 1 with auto-renumbering
- Status bar at the top, centered, transparent background
- Vi key mode, mouse support enabled, zero escape time
- TPM (Tmux Plugin Manager) via git submodule

---

## Ghostty (`avalore/.config/ghostty/config`)

| Setting | Value |
|---------|-------|
| Font size | 18 |
| Background | `#212121` |
| Background blur radius | 20 |
| Window padding (x) | 16px |
| Hide mouse while typing | Yes |

---

## Shell

### Bash (`.bashrc`) — Linux

- Vi mode (`set -o vi`)
- Custom prompt showing `user@host`, current directory, and git branch status (`✓` for clean, `±` for dirty)
- `Ctrl-p` launches a tmux session picker script

**Aliases:**

| Alias | Command |
|-------|---------|
| `ls` | `ls -l --color=auto` |
| `lsl` | `ls -al --color=auto` |
| `sys` | `sudo systemctl` |
| `tm` | `tmux` |
| `nm` | `neomutt` |
| `ncs` | Launch nRF Connect SDK shell (v3.2.1) |

### Zsh (`.zshrc`) — macOS

- Vi mode (`bindkey -v`)
- Minimal two-line prompt with git-friendly `setopt prompt_subst`
- fzf integration via `~/.fzf.zsh`

**Aliases:**

| Alias | Command |
|-------|---------|
| `ls` | `eza -l --icons --git` |
| `lsl` | `eza -l --icons --git -a` |
| `lt` | `eza --tree --level=2 --long --icons --git` |
| `tm` | `tmux` |

---

## License

MIT — see [LICENSE](LICENSE).
