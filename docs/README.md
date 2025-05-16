# Crazychenz's `.dotfiles`

Offline, All The Things, Config:

```sh
# Install GNU Stow
sudo apt-get install stow

# Clone .dotfiles repo
cd && git clone https://github.com/crazychenz/.dotfiles.git

# Collect user specific applications (assumes docker installed).
cd .dotfiles/offline/collector && ./bundle.sh

# Install user specific applications to ~/.local.
cd && ./.dotfiles/offline/collector/x64-linux_config_install.sh

# Initialize user specific configurations.
cd ./.dotfiles/offline && stow --target=$HOME * && source ~/.bash-user-settings.sh
```

Lighter, Online, More Deliberate, Config:

```sh
# Install GNU Stow
sudo apt-get install stow

# Clone .dotfiles repo
cd && git clone https://github.com/crazychenz/.dotfiles.git

# Manually install Debian, Neovim 10+, LightDM, i3, urxvt, tmux.
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Initialize user specific configurations.
cd ./.dotfiles/mouseless && stow --target=$HOME * && source ~/.bash-user-settings.sh
```


## Stack Includes

- bash configs
- git configs

- Tmux - terminal multiplexer (https://github.com/mjakob-gh/build-static-tmux/releases)
- Tmux Plugin Manager (https://github.com/tmux-plugins/tpm)
- NeoVim (https://github.com/neovim/neovim/releases)
- NvChad Starter - supercharge neovim with zero effort
- LazyGit - Git TUI (https://github.com/jesseduffield/lazygit)
- Vivid - Terminal Color Themer (https://github.com/sharkdp/vivid/releases)
- Yazi - File Manager TUI (https://github.com/sxyazi/yazi)
- glow - Terminal Markdown Presenter (https://github.com/charmbracelet/glow)
- kubectl - k3s-based k8s client (https://github.com/k3s-io/k3s/releases)
- ketall - for realz "kubectl get-all" (https://github.com/corneliusweig/ketall/releases)
- k9s - K8s TUI (https://github.com/derailed/k9s)
- btop - System Resource Monitor TUI (https://github.com/aristocratos/btop)
- uv - rust-based python package installer (https://docs.astral.sh/uv)
- posting - postman-ish TUI (https://posting.sh/guide)
- curlie - httpie with power of curl (https://github.com/rs/curlie)
- zoxide - smart heuristic based cd (i.e. change directory) (https://github.com/ajeetdsouza/zoxide)
- fzf - cli fuzzy finder (https://github.com/junegunn/fzf)
- bat - cat with syntax highlighting (https://github.com/sharkdp/bat)
- kanata - key mapper for home row mods (https://github.com/jtroo/kanata/releases)
- fd - modern find command (https://github.com/sharkdp/fd)
- ripgrep - grep for git repos (https://github.com/BurntSushi/ripgrep)
- eza - modern ls (https://github.com/eza-community/eza / https://eza.rocks/)
- delta - modern git diff pager (https://github.com/dandavison/delta)
