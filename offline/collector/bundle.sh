#!/bin/sh

export OPEN_SHELL=no
./collect.sh

#tar -cf bundle.tar bundle/x64-linux
SCRIPT_NAME=x64-linux_apps_install.sh
TARFLAG="" # optionally add compression flag (gzip=>-z, bzip2=>-j, xz=>-J)
cat >${SCRIPT_NAME} <<SH_EOF
#!/bin/sh
export DEST=home_config_backup-\$(date +%Y%m%d-%H%M%S) ; mkdir \${DEST} ; mkdir .local ; rsync -a .local/ \${DEST}/.local/
sed '1,10d' \$0 | tar --strip-components=2 -x
[ -e ".bashrc" -a -z "\$(grep 'bash-user-settings.sh' .bashrc)" ] && echo "source ~/.bash-user-settings.sh" >> .bashrc




exit 0
# Verbatim tar data following this 10th line.
SH_EOF
tar $TARFLAG -c bundle/x64-linux >>${SCRIPT_NAME}
chmod +x ${SCRIPT_NAME}

