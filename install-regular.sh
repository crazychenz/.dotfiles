#!/usr/bin/env bash

# You need to install python3, which, tput, c compiler, ncurses-utils.
# You may need to `pip install pyyam`.

set -e

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd "${BASEDIR}"
#git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
#git submodule update --init --recursive "${DOTBOT_DIR}"
"${BASEDIR}/dotbot/bin/dotbot" -d "${BASEDIR}" -c "dotfiles.conf.yaml" "${@}"
[ -e "${BASEDIR}/binaries/binaries.conf.yaml" ] \
  && "${BASEDIR}/dotbot/bin/dotbot" -d "${BASEDIR}" -c "binaries/binaries.conf.yaml" "${@}"
popd

if [ ! -e ~/.bashrc ]; then touch ~/.bashrc ; fi 
sed -i '/# \[ dotfiles entry start \]/,/# \[ dotfiles entry end \]/d' ~/.bashrc
cat <<EOF >>~/.bashrc
# [ dotfiles entry start ]
source ~/.bash-user-settings.sh
# [ dotfiles entry end ]
EOF

if [ ! -e ~/.profile ]; then touch ~/.profile ; fi 
sed -i '/# \[ dotfiles entry start \]/,/# \[ dotfiles entry end \]/d' ~/.profile
cat <<EOF >>~/.profile
# [ dotfiles entry start ]
source ~/.bash-user-profile.sh
# [ dotfiles entry end ]
EOF
