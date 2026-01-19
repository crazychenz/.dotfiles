#!/usr/bin/env bash

# You need to install python3, which, tput, c compiler, ncurses-utils.
# You may need to `pip install pyyam`.

set -e

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd "${BASEDIR}"
  "${BASEDIR}/dotbot/bin/dotbot" -d "${BASEDIR}" -c "fonts-dotfiles.conf.yaml" "${@}"
popd

fc-cache -f -v
