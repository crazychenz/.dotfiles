#!/usr/bin/env bash
selected=`cat ~/.config/tmux/tmux-cht-languages ~/.config/tmux/tmux-cht-command | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/.tmux-cht-languages; then
    query=`echo $query | tr ' ' '+'`
    bash -l -c "curl cht.sh/$selected/$query | less -R"
else
    curl -s cht.sh/$selected~$query | less
fi
