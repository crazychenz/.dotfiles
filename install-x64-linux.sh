#!/usr/bin/env bash

set -e

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd "${BASEDIR}"

"${BASEDIR}/dotbot/bin/dotbot" \
  -d "${BASEDIR}/collectors/x64-linux" \
  -c "${BASEDIR}/collectors/x64-linux/dotfiles.conf.yaml" "${@}"

popd

