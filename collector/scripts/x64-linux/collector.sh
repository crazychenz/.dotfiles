#!/bin/bash 

USER_SETTINGS_FPATH=${HOME}/.bash-user-settings.sh
DOWNLOADS=/opt/downloads/

K3S_VERSION=v1.30.0%2Bk3s1
KETALL_VERSION=v1.3.8
TMUX_VERSION=v3.3a
NVIM_VERSION=v0.10.3
LAZYGIT_VERSION=0.45.2
VIVID_VERSION=v0.10.1
YAZI_VERSION=v0.4.2
GLOW_VERSION=2.0.0

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
zcat ${DOWNLOADS}tmux.linux-amd64.gz > ${HOME}/.local/bin/tmux
chmod +x ${HOME}/.local/bin/tmux


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
tar -C ${DOWNLOADS} -xf ${DOWNLOADS}lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz
cp ${DOWNLOADS}lazygit ${HOME}/.local/bin/


### Install Vivid
try_to_download vivid-${VIVID_VERSION}-x86_64-unknown-linux-musl.tar.gz \
  https://github.com/sharkdp/vivid/releases/download/${VIVID_VERSION}/vivid-${VIVID_VERSION}-x86_64-unknown-linux-musl.tar.gz
tar -xf vivid-${VIVID_VERSION}-x86_64-unknown-linux-musl.tar.gz
cp /opt/downloads/vivid-${VIVID_VERSION}-x86_64-unknown-linux-musl/vivid ${HOME}/.local/bin/


### Install Yazi
try_to_download yazi-x86_64-unknown-linux-musl.zip \
  https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-musl.zip
pushd ${DOWNLOADS} ; unzip -o yazi-x86_64-unknown-linux-musl.zip ; popd ${DOWNLOADS}
cp ${DOWNLOADS}yazi-x86_64-unknown-linux-musl/yazi ${HOME}/.local/bin/
cp ${DOWNLOADS}yazi-x86_64-unknown-linux-musl/ya ${HOME}/.local/bin/


### Install glow
try_to_download glow_${GLOW_VERSION}_Linux_x86_64.tar.gz \
  https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_Linux_x86_64.tar.gz
tar -C ${DOWNLOADS} -xf ${DOWNLOADS}glow_${GLOW_VERSION}_Linux_x86_64.tar.gz
cp ${DOWNLOADS}glow_${GLOW_VERSION}_Linux_x86_64/glow ${HOME}/.local/bin/


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
tar -C ${HOME}/.local/bin/ -xf ${DOWNLOADS}k9s_Linux_amd64.tar.gz


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



