#!/bin/bash

cd mouseless && stow -D --target="$(realpath ~)" *

sed -i '/# \[ dotfiles entry start \]/,/# \[ dotfiles entry end \]/d' ~/.bashrc

sed -i '/# \[ dotfiles entry start \]/,/# \[ dotfiles entry end \]/d' ~/.profile

