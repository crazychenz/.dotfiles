# Crazychenz's `.dotfiles`

Standard Use Case:

```sh
# Clone .dotfiles repo
cd && git clone https://github.com/crazychenz/.dotfiles.git

# Optional: Move .dotfiles to /opt/dotfiles for VM access.
sudo mv ~/.dotfiles /opt/dotfiles
sudo chown -R $(id -u):$(id -g) /opt/dotfiles
ln -s /opt/dotfiles ~/.dotfiles

# Optional: Download/Install x64-linux-gnu binaries.
cd .dotfiles/collectors/x64-linux && ./collector.sh
cd .dotfiles && ./install-x64-linux.sh

# Optional: Download/Install extra x64-linux-gnu binaries.
cd ~/.dotfiles/collectors/x64-linux-extra && ./collector.sh
cd ~/.dotfiles && ./install-extra-x64-linux.sh

# ** Initialize user specific configurations. **
cd ~/.dotfiles && ./install-configs.sh

# Logout/Login or Activate new shell config now.
bash --login
```


## Stack Includes

- bash configs (profile for login, and bashrc hook for each instance.)
- git configs (.gitconfig copied, not linked.)

- x64-linux-gnu Binaries Collector:

  - Tmux - terminal multiplexer (https://github.com/mjakob-gh/build-static-tmux/releases)
    - Special configuration that is biased against using plugins.

  - NeoVim (https://github.com/neovim/neovim/releases)
    - Config include 90% of functionality without plugins and included at top.

  - bat - cat with syntax highlighting (https://github.com/sharkdp/bat)
  - broot - TUI file _explorer_
  - btop - System Resource Monitor TUI (https://github.com/aristocratos/btop)
  - curlie - httpie with power of curl (https://github.com/rs/curlie)
  - delta - modern git diff pager (https://github.com/dandavison/delta)
  - eza - modern ls (https://github.com/eza-community/eza / https://eza.rocks/)
  - fd - modern find command (https://github.com/sharkdp/fd)
  - fzf - cli fuzzy finder (https://github.com/junegunn/fzf)
  - glow - Terminal Markdown Presenter (https://github.com/charmbracelet/glow)
  - gopass - console password and secret management (uses GPG)
  - k3s - collection of tools used to host a full k8s cluster. (https://github.com/k3s-io/k3s/releases)
    - kubectl - k3s-based k8s client (https://github.com/k3s-io/k3s/releases)
    - ketall - for realz "kubectl get-all" (https://github.com/corneliusweig/ketall/releases)
  - k9s - K8s TUI (https://github.com/derailed/k9s)
  - kanata - key mapper for home row mods (https://github.com/jtroo/kanata/releases)
  - lazydocker - docker service manager
  - lazygit - Git TUI (https://github.com/jesseduffield/lazygit)
  - Vivid - Terminal Color Themer (https://github.com/sharkdp/vivid/releases)
  - Yazi - File Manager TUI (https://github.com/sxyazi/yazi)
  - zoxide - smart heuristic based cd (i.e. change directory) (https://github.com/ajeetdsouza/zoxide)

  <!--
  #- uv - rust-based python package installer (https://docs.astral.sh/uv)
  #- posting - postman-ish TUI (https://posting.sh/guide)
  #- ripgrep - grep for git repos (https://github.com/BurntSushi/ripgrep) 
  -->

- x64-linux-gnu-extra Binaries Collector:

  - dive - Docker layer analysis
  - edit - Retro Microsoft Editor
  - fq - like jq for binary formats
  - gping - ping visualizer
  - isd - systemctl tui
  - lazyjournal - journalctl tui
  - mdtt - markdown table editor
  - mlr - miller cli data processor
  - monolith - website downloader
  - otree - JSON/YAML/TOML tree view
  - rainfrog - Postgres Management
  - rclone - rsync for cloud protocols
  - so - StackOVerflow TUI
  - termshark - Wireshark TUI
  - tjournal - TUI for journaling (stored in SQLite)
  - typioca - Typing tester
  - wtfutil - TUI Dashboard

## Other Configurations

- keyboard - configurations for keyboard microcontroller firmwares
- windows - configurations for windows tools (not POSIX compatible)






