#!/usr/bin/env bash

# You need to install python3, which, tput, c compiler, ncurses-utils.
# You may need to `pip install pyyam`.

set -e

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd "${BASEDIR}"
  "${BASEDIR}/dotbot/bin/dotbot" -d "${BASEDIR}" -c "gtk-dotfiles.conf.yaml" "${@}"
popd

if [ -n "$(which update-desktop-database)" ]; then
  update-desktop-database ~/.local/share/applications/
fi

if [ -n "$(which kbuildsycoca6)" ]; then
  kbuildsycoca6 --noincremental
fi

for app in pinta zen.AppImage wezterm.AppImage drawio.AppImage codium.AppImage zulip.AppImage; do
  if [ -z "$(which $app)" ]; then
    echo $app not detected, but expected in PATH.
  fi
done





