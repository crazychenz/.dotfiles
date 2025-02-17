#!/bin/bash 

USER_SETTINGS_FPATH=${HOME}/.bash-user-settings.sh
DOWNLOADS=/opt/downloads/

UV_VERSION=0.6.0
K3S_VERSION=v1.30.0%2Bk3s1
KETALL_VERSION=v1.3.8
TMUX_VERSION=v3.3a
NVIM_VERSION=v0.10.3
LAZYGIT_VERSION=0.45.2
VIVID_VERSION=v0.10.1
YAZI_VERSION=v0.4.2
GLOW_VERSION=2.0.0
CURLIE_VERSION=1.7.2
ZOXIDE_VERSION=0.9.7
FZF_VERSION=0.60.0
BAT_VERSION=0.25.0
KANATA_VERISON=1.8.0
FD_VERSION=10.2.0
RIPGREP_VERSION=14.1.1
EZA_VERSION=0.20.21

VIVID_THEME=catppuccin-mocha
LAZYGIT_THEME=mocha/blue.yml
YAZI_THEME=mocha/catppuccin-mocha-yellow.toml
BTOP_THEME=catppuccin_mocha.theme
K9S_THEME=catppuccin-mocha

### Initialize config setup
mkdir -p ${HOME}/.local/bin && chmod 700 ${HOME}/.local


# The main downloader function.
try_to_download() {
  FNAME=$1
  URL=$2
  pushd ${DOWNLOADS}
  if [ -e "${FNAME}" ]; then
    echo "${FNAME} already downloaded. Skipping"
  else
    curl -L -o "${FNAME}" ${URL}
  fi
  popd
}


# Install Tmux (https://github.com/mjakob-gh/build-static-tmux/releases)
try_to_download tmux.linux-amd64.gz \
  https://github.com/mjakob-gh/build-static-tmux/releases/download/${TMUX_VERSION}/tmux.linux-amd64.gz
zcat ${DOWNLOADS}tmux.linux-amd64.gz > ${HOME}/.local/bin/tmux && chmod +x ${HOME}/.local/bin/tmux


# Install Tmux Plugin Manager (https://github.com/tmux-plugins/tpm)
mkdir -p ${HOME}/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
# Manually:
# tmux start-server
# tmux new-session -d
# ${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh
# tmux kill-server


### Setup NeoVim

# Challenges with NeoVim:
# - NeoVim is a dynamic library requiring glibc. AppImage also reqs GNU.
#   - In Alpine we must install neovim from apk repo.
# - AppImage requires fuse (a kernel module), something not everywhere.
# - Nvchad reqs a compiler. (debian - build_essential, alpine - build-base)

# Upstream NeoVim (https://github.com/neovim/neovim/releases)
try_to_download nvim-linux64.tar.gz \
  https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz
tar -C ${HOME}/.local/ -xf ${DOWNLOADS}nvim-linux64.tar.gz

# TODO: How do we determine it is safe to symlink nvim to PATH?
# TODO: How do we determine it is safe to run this?
#${HOME}/.local/nvim/bin/nvim --headless "+Lazy! sync" +qa
# TODO: How do we do this outside of ~/.local/share ?!
#patch ${HOME}/.local/share/nvim/lazy/NvChad/lua/nvchad/configs/cmp.lua cmd-mapping-confirm.patch


### Install LazyGit
try_to_download lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz \
  https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz
tar -C ${HOME}/.local/bin -xf ${DOWNLOADS}lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz lazygit


### Install Vivid
try_to_download vivid-${VIVID_VERSION}-x86_64-unknown-linux-musl.tar.gz \
  https://github.com/sharkdp/vivid/releases/download/${VIVID_VERSION}/vivid-${VIVID_VERSION}-x86_64-unknown-linux-musl.tar.gz
tar --strip-components=1 -C ${HOME}/.local/bin \
  -xf vivid-${VIVID_VERSION}-x86_64-unknown-linux-musl.tar.gz \
  vivid-${VIVID_VERSION}-x86_64-unknown-linux-musl/vivid


### Install Yazi
try_to_download yazi-x86_64-unknown-linux-musl.zip \
  https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-musl.zip
pushd ${DOWNLOADS} ; unzip -o yazi-x86_64-unknown-linux-musl.zip ; popd ${DOWNLOADS}
cp ${DOWNLOADS}yazi-x86_64-unknown-linux-musl/yazi ${HOME}/.local/bin/
cp ${DOWNLOADS}yazi-x86_64-unknown-linux-musl/ya ${HOME}/.local/bin/


### Install glow
try_to_download glow_${GLOW_VERSION}_Linux_x86_64.tar.gz \
  https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_Linux_x86_64.tar.gz
tar --strip-components=1 -C ${HOME}/.local/bin \
  -xf ${DOWNLOADS}glow_${GLOW_VERSION}_Linux_x86_64.tar.gz glow_${GLOW_VERSION}_Linux_x86_64/glow


### Install kubectl (k3s as client) (https://github.com/k3s-io/k3s/releases)
try_to_download k3s \
  https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s
  # Install k3s to bundle
chmod +x ${DOWNLOADS}k3s ; cp ${DOWNLOADS} k3s ${HOME}/.local/bin/
pushd ${HOME}/.local/bin ; ln -s k3s kubectl ; popd


## Install flux (https://github.com/fluxcd/flux2/releases)
#try_to_download flux_2.3.0_linux_amd64.tar.gz \
#  https://github.com/fluxcd/flux2/releases/download/v2.3.0/flux_2.3.0_linux_amd64.tar.gz


# Install ketall (https://github.com/corneliusweig/ketall/releases)
try_to_download get-all-amd64-linux.tar.gz \
  https://github.com/corneliusweig/ketall/releases/download/$KETALL_VERSION/get-all-amd64-linux.tar.gz
tar -C ${DOWNLOADS} -xf ${DOWNLOADS}get-all-amd64-linux.tar.gz get-all-amd64-linux
mv ${DOWNLOADS}get-all-amd64-linux ${HOME}/.local/bin/kubectl-get_all


# Install k9s
try_to_download k9s_Linux_amd64.tar.gz \
  https://github.com/derailed/k9s/releases/download/v0.32.7/k9s_Linux_amd64.tar.gz
tar -C ${HOME}/.local/bin/ -xf ${DOWNLOADS}k9s_Linux_amd64.tar.gz k9s


### Setup btop

# Theme btop.
mkdir -p ${HOME}/.config/catppuccin/ && cd ${HOME}/.config/catppuccin/ 
git clone https://github.com/catppuccin/btop
mkdir -p ${HOME}/.config/btop/themes
cp ${HOME}/.config/catppuccin/btop/themes/${BTOP_THEME} ${HOME}/.config/btop/themes/


### Setup tty

# This requires manual setup, but we'll throw themes in the bundle.
mkdir -p ${HOME}/.config/catppuccin/ && cd ${HOME}/.config/catppuccin/ 
git clone https://github.com/catppuccin/tty


# Install uv - rust-based python package installer (https://docs.astral.sh/uv)
curl -LsSf https://astral.sh/uv/${UV_VERSION}/install.sh | sh


# Install posting with uv, gets installed into ~/.local/share/uv (https://posting.sh/guide)
${HOME}/.local/bin/uv tool install posting


# Install curlie - httpie with power of curl (https://github.com/rs/curlie)
try_to_download curlie_${CURLIE_VERSION}_linux_amd64.tar.gz \
  https://github.com/rs/curlie/releases/download/v${CURLIE_VERSION}/curlie_${CURLIE_VERSION}_linux_amd64.tar.gz
tar -C ${HOME}/.local/bin/ -xf ${DOWNLOADS}curlie_${CURLIE_VERSION}_linux_amd64.tar.gz curlie


# Install zoxide - smart cd (i.e. change directory) (https://github.com/ajeetdsouza/zoxide)
#try_to_download zoxide-${ZOXIDE_VERSION}-x86_64-unknown-linux-musl.tar.gz \
#  https://github.com/ajeetdsouza/zoxide/releases/download/v${ZOXIDE_VERSION}/zoxide-${ZOXIDE_VERSION}-x86_64-unknown-linux-musl.tar.gz
#tar -C ${HOME}/.local/bin/ -xf ${DOWNLOADS}zoxide-${ZOXIDE_VERSION}-x86_64-unknown-linux-musl.tar.gz zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh


# Install fzf - cli fuzzy finder (https://github.com/junegunn/fzf)
# Note: Need to ensure pkg manager didn't install version previous to 0.48.
try_to_download fzf-${FZF_VERSION}-linux_amd64.tar.gz \
  https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz
tar -C ${HOME}/.local/bin/ -xf ${DOWNLOADS}fzf-${FZF_VERSION}-linux_amd64.tar.gz fzf


# Install bat - cat with syntax highlighting (https://github.com/sharkdp/bat)
try_to_download bat-v${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz \
  https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz
tar --strip-components=1 -C ${HOME}/.local/bin \
  -xf ${DOWNLOADS}bat-v${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz \
  bat-v${BAT_VERSION}-x86_64-unknown-linux-musl/bat


# Install kanata - key mapper (https://github.com/jtroo/kanata/releases)
try_to_download kanata \
  https://github.com/jtroo/kanata/releases/download/v${KANATA_VERSION}/kanata
cp ${DOWNLOADS}kanata ${HOME}/.local/bin && chmod +x ${HOME}/.local/bin/kanata


# Install fd - modern find command (https://github.com/sharkdp/fd)
try_to_download fd-v${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz \
  https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz
tar --strip-components=1 -C ${HOME}/.local/bin \
  -xf ${DOWNLOADS}fd-v${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz \
  fd-v${FD_VERSION}-x86_64-unknown-linux-musl/fd


# Install ripgrep - grep for git repos (https://github.com/BurntSushi/ripgrep)
try_to_download ripgrep-${RIPGREP_VERSION}-x86_64-unknown-linux-musl.tar.gz \
  https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep-${RIPGREP_VERSION}-x86_64-unknown-linux-musl.tar.gz
tar --strip-components=1 -C ${HOME}/.local/bin \
  -xf ${DOWNLOADS}ripgrep-${RIPGREP_VERSION}-x86_64-unknown-linux-musl.tar.gz \
  ripgrep-${RIPGREP_VERSION}-x86_64-unknown-linux-musl/rg


# Install exa - modern ls (https://github.com/eza-community/eza / https://eza.rocks/)
try_to_download eza_x86_64-unknown-linux-musl.tar.gz \
  https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_x86_64-unknown-linux-musl.tar.gz
tar -C ${HOME}/.local/bin -xf ${DOWNLOADS}eza_x86_64-unknown-linux-musl.tar.gz eza

### End of script, open shell if indicated.

cd /home/user
if [ "${OPEN_SHELL}" == "yes" ]; then
  /bin/bash -i
fi

### Other tools to consider integrating:
# starship
#   theme: https://github.com/catppuccin/starship
# lsd
#   theme: https://github.com/catppuccin/lsd
# cutter
#   theme: https://github.com/catppuccin/cutter
# fzf
#   theme: https://github.com/catppuccin/fzf


### Other tools to consider looking at:
#
# Ghidra - binary analysis
# aerc - email client
#   theme: https://github.com/catppuccin/aerc
# imhex
#   theme: https://github.com/catppuccin/imhex
# spotify-tui
#   theme: https://github.com/catppuccin/spotify-tui
# asciinema
#   theme: https://github.com/catppuccin/asciinema
# lxqt
#   theme: https://github.com/catppuccin/lxqt
# duckduckgo
#   theme: https://github.com/catppuccin/duckduckgo


### Other things to checkout, but not here.
#
# sidebery - firefox bookmark manager
# insomnia - postman oss
# brave browser
# firefox
# notepad-plus-plus
# vscodium
# zed
# alacritty



