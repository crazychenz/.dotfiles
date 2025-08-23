#!/bin/bash

cd shared && stow --target="$(realpath ~)" *

sed -i '/# \[ dotfiles entry start \]/,/# \[ dotfiles entry end \]/d' ~/.bashrc
cat <<EOF >>~/.bashrc
# [ dotfiles entry start ]

source ~/.bash-user-settings.sh

# [ dotfiles entry end ]
EOF

sed -i '/# \[ dotfiles entry start \]/,/# \[ dotfiles entry end \]/d' ~/.profile
cat <<EOF >>~/.profile
# [ dotfiles entry start ]

source ~/.bash-user-profile.sh

# [ dotfiles entry end ]
EOF

