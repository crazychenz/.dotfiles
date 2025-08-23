#!/bin/bash

NVIM_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")/nvim-portable" && pwd)"
export XDG_CONFIG_HOME="$NVIM_HOME/config"
export XDG_DATA_HOME="$NVIM_HOME/plugins"
exec "$NVIM_HOME/bin/nvim" "$@"
