#!/bin/bash

# Goal: Download latest of a thing and attempt to get the version.
# Goal: Only acquire statically linked things.


DOWNLOADS=bundle/downloads/
BINDIR=bundle/.local/bin/
CFGDIR=bundle/.config/
mkdir -p ${DOWNLOADS}
mkdir -p ${BINDIR}
mkdir -p ${CFGDIR}

github_latest_release_version() {
  REPO=$1
  basename $(curl -s -o /dev/null -w "%{redirect_url}" "https://github.com/${REPO}/releases/latest")
}

github_download_version() {
  REPO=$1
  VERSION=$2
  FNAME=$3

  SOURCE_PREFIX=$(echo "${REPO}" | sed 's#/#%2F#g')

  if [ -e "${DOWNLOADS}${FNAME}" ]; then
    echo "${FNAME} already downloaded. Skipping"
  else
    VERSIONED_URL=https://github.com/${REPO}/releases/download/${VERSION}
    echo "Downloading: ${VERSIONED_URL}/${FNAME}"
    curl -o ${DOWNLOADS}${FNAME} -L "${VERSIONED_URL}/${FNAME}"
  fi

  SOURCE_FNAME=$(echo "${REPO}" | sed 's#/#%2F#g')-${VERSION}.tar.gz
  if [ -e "${DOWNLOADS}${SOURCE_FNAME}" ]; then
    echo "${SOURCE_FNAME} already downloaded. Skipping"
  else
    curl -o ${DOWNLOADS}${SOURCE_FNAME} -L "https://github.com/${REPO}/archive/refs/tags/${VERSION}.tar.gz"
  fi
}

dependency_check() {
  if [ -z "$(which $2)" ]; then
    echo "You need $2 in \$PATH to use $1."
    exit 1
  fi
}

dependency_check $0 curl
dependency_check $0 tar
dependency_check $0 gzip
dependency_check $0 unzip
dependency_check $0 awk
dependency_check $0 git

### Tmux
VERSION=$(github_latest_release_version mjakob-gh/build-static-tmux)
FNAME=tmux.linux-amd64.stripped.gz
github_download_version mjakob-gh/build-static-tmux $VERSION ${FNAME}
echo Installing: ${FNAME}
cp ${DOWNLOADS}${FNAME} ${BINDIR}tmux.gz && gzip -f -d ${BINDIR}tmux.gz && chmod +x ${BINDIR}tmux

### Install LazyGit
VERSION=$(github_latest_release_version jesseduffield/lazygit)
FNAME=lazygit_$(echo -n $VERSION | cut -c2-)_linux_x86_64.tar.gz
github_download_version jesseduffield/lazygit $VERSION $FNAME
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} lazygit

### Install Vivid
VERSION=$(github_latest_release_version sharkdp/vivid)
FNAME=vivid-${VERSION}-x86_64-unknown-linux-musl.tar.gz
github_download_version sharkdp/vivid $VERSION ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} --strip-components=1 vivid-${VERSION}-x86_64-unknown-linux-musl/vivid
mkdir -p ${CFGDIR}vivid
tar -xf ${DOWNLOADS}${FNAME} -C ${CFGDIR}vivid --strip-components=1 vivid-${VERSION}-x86_64-unknown-linux-musl/autocomplete

### Install Yazi
VERSION=$(github_latest_release_version sxyazi/yazi)
FNAME=yazi-x86_64-unknown-linux-musl.zip
github_download_version sxyazi/yazi $VERSION ${FNAME}
echo Installing: ${FNAME}
unzip -o -j ${DOWNLOADS}${FNAME} yazi-x86_64-unknown-linux-musl/{yazi,ya} -d ${BINDIR}
mkdir -p ${CFGDIR}yazi/completions
unzip -o -j ${DOWNLOADS}${FNAME} "yazi-x86_64-unknown-linux-musl/completions/*" -d ${CFGDIR}yazi/completions


### Install glow
VERSION=$(github_latest_release_version charmbracelet/glow)
FNAME=glow_$(echo -n $VERSION | cut -c2-)_Linux_x86_64.tar.gz
github_download_version charmbracelet/glow $VERSION ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} --strip-components=1 glow_$(echo -n $VERSION | cut -c2-)_Linux_x86_64/glow
mkdir -p ${CFGDIR}glow
tar -xf ${DOWNLOADS}${FNAME} -C ${CFGDIR}glow --strip-components=1 glow_$(echo -n $VERSION | cut -c2-)_Linux_x86_64/completions 


### Install kubectl (k3s as client) (https://github.com/k3s-io/k3s/releases)
VERSION=$(github_latest_release_version k3s-io/k3s)
github_download_version k3s-io/k3s $VERSION k3s
github_download_version k3s-io/k3s $VERSION k3s-airgap-images-amd64.tar.gz
echo Installing: ${FNAME}
cp ${DOWNLOADS}k3s ${BINDIR}k3s && chmod +x ${BINDIR}k3s && ln -s k3s ${BINDIR}kubectl

## Install flux (https://github.com/fluxcd/flux2/releases)
#try_to_download flux_2.3.0_linux_amd64.tar.gz \
#  https://github.com/fluxcd/flux2/releases/download/v2.3.0/flux_2.3.0_linux_amd64.tar.gz


# Install ketall (https://github.com/corneliusweig/ketall/releases)
VERSION=$(github_latest_release_version corneliusweig/ketall)
FNAME=get-all-amd64-linux.tar.gz
github_download_version corneliusweig/ketall $VERSION ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} get-all-amd64-linux \
  && mv ${BINDIR}get-all-amd64-linux ${BINDIR}kubectl-get_all


# Install k9s
VERSION=$(github_latest_release_version derailed/k9s)
FNAME=k9s_Linux_amd64.tar.gz
github_download_version derailed/k9s $VERSION ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} k9s


### fzf
VERSION=$(github_latest_release_version junegunn/fzf)
FNAME=fzf-$(echo -n $VERSION | cut -c2-)-linux_amd64.tar.gz
github_download_version junegunn/fzf $VERSION ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} fzf



### bat
VERSION=$(github_latest_release_version sharkdp/bat)
FNAME=bat-${VERSION}-x86_64-unknown-linux-musl.tar.gz
github_download_version sharkdp/bat $VERSION ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} --strip-components=1 bat-${VERSION}-x86_64-unknown-linux-musl/bat
mkdir -p ${CFGDIR}bat
tar -xf ${DOWNLOADS}${FNAME} -C ${CFGDIR}bat --strip-components=1 bat-${VERSION}-x86_64-unknown-linux-musl/autocomplete


### btop
VERSION=$(github_latest_release_version aristocratos/btop)
FNAME=btop-i686-linux-musl.tbz
github_download_version aristocratos/btop $VERSION ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} --strip-components=3 ./btop/bin/btop
mkdir -p ${CFGDIR}btop
tar -xf ${DOWNLOADS}${FNAME} -C ${CFGDIR}btop --strip-components=2 ./btop/themes


### curlie
VERSION=$(github_latest_release_version rs/curlie)
FNAME=curlie_$(echo -n $VERSION | cut -c2-)_linux_amd64.tar.gz
github_download_version rs/curlie $VERSION ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} curlie


### delta
VERSION=$(github_latest_release_version dandavison/delta)
FNAME=delta-${VERSION}-x86_64-unknown-linux-musl.tar.gz
github_download_version dandavison/delta $VERSION ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} --strip-components=1 delta-${VERSION}-x86_64-unknown-linux-musl/delta


### eza
VERSION=$(github_latest_release_version eza-community/eza)
FNAME=eza_x86_64-unknown-linux-musl.tar.gz
github_download_version eza-community/eza $VERSION ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} ./eza


### fd
VERSION=$(github_latest_release_version sharkdp/fd)
FNAME=fd-${VERSION}-x86_64-unknown-linux-musl.tar.gz
github_download_version sharkdp/fd $VERSION ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} --strip-components=1 fd-${VERSION}-x86_64-unknown-linux-musl/fd
mkdir -p ${CFGDIR}fd
tar -xf ${DOWNLOADS}${FNAME} -C ${CFGDIR}fd --strip-components=1 fd-${VERSION}-x86_64-unknown-linux-musl/autocomplete



### gopass
VERSION=$(github_latest_release_version gopasspw/gopass)
FNAME=gopass-$(echo -n $VERSION | cut -c2-)-linux-amd64.tar.gz
github_download_version \
  gopasspw/gopass $VERSION gopass-$(echo -n $VERSION | cut -c2-)-linux-amd64.tar.gz
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} gopass
mkdir -p ${CFGDIR}gopass/completions
tar -xf ${DOWNLOADS}${FNAME} -C ${CFGDIR}gopass/completions --wildcards "*.completion"


### lazydocker
VERSION=$(github_latest_release_version jesseduffield/lazydocker)
FNAME=lazydocker_$(echo -n $VERSION | cut -c2-)_Linux_x86_64.tar.gz
github_download_version jesseduffield/lazydocker $VERSION ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} lazydocker

### zoxide
VERSION=$(github_latest_release_version ajeetdsouza/zoxide)
FNAME=zoxide-$(echo -n $VERSION | cut -c2-)-x86_64-unknown-linux-musl.tar.gz
github_download_version ajeetdsouza/zoxide $VERSION ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR} zoxide
mkdir -p ${CFGDIR}zoxide
tar -xf ${DOWNLOADS}${FNAME} -C ${CFGDIR}zoxide completions


### kanata
VERSION=$(github_latest_release_version jtroo/kanata)
github_download_version jtroo/kanata $VERSION kanata
echo Installing: ${FNAME}
cp ${DOWNLOADS}kanata ${BINDIR} && chmod +x ${BINDIR}kanata

### broot
VERSION=$(github_latest_release_version Canop/broot)
FNAME=broot_$(echo -n $VERSION | cut -c2-).zip
github_download_version Canop/broot $VERSION ${FNAME}
echo Installing: ${FNAME}
unzip -o -j ${DOWNLOADS}${FNAME} "x86_64-unknown-linux-musl/broot" -d ${BINDIR}
mkdir -p ${CFGDIR}broot/{completion,default-conf}
unzip -o -j ${DOWNLOADS}${FNAME} "completion/*" -d ${CFGDIR}broot/completion
unzip -o -j ${DOWNLOADS}${FNAME} "default-conf/*" -d ${CFGDIR}broot/default-conf

### TODO: posting (no binary release)

### neovim
VERSION=$(github_latest_release_version neovim/neovim)
FNAME=nvim-linux-x86_64.tar.gz
github_download_version neovim/neovim $VERSION ${FNAME}
echo Installing: ${FNAME}
tar -xf ${DOWNLOADS}${FNAME} -C ${BINDIR}
cp nvim ${BINDIR}

exit 0


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

USER_SETTINGS_FPATH=${HOME}/.bash-user-settings.sh

VIVID_THEME=catppuccin-mocha
LAZYGIT_THEME=mocha/blue.yml
YAZI_THEME=mocha/catppuccin-mocha-yellow.toml
BTOP_THEME=catppuccin_mocha.theme
K9S_THEME=catppuccin-mocha

# Install Tmux Plugin Manager (https://github.com/tmux-plugins/tpm)
mkdir -p ${HOME}/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
# Manually:
# tmux start-server
# tmux new-session -d
# ${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh
# tmux kill-server




