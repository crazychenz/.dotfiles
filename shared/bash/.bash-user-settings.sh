COLOR_RESET="$(tput sgr0)"
if [ -e "$(realpath ~)/.light_theme" ]; then
  COLOR_LIGHT_BROWN="$(tput setaf 178)"
  COLOR_LIGHT_PURPLE="$(tput setaf 90)"
  COLOR_LIGHT_BLUE="$(tput setaf 61)"
  COLOR_LIGHT_GREEN="$(tput setaf 70)"
  COLOR_LIGHT_YELLOW="$(tput setaf 94)"
  COLOR_YELLOW="$(tput setaf 184)"
  COLOR_GREEN="$(tput setaf 64)"
  COLOR_ORANGE="$(tput setaf 208)"
  COLOR_RED="$(tput setaf 196)"
  COLOR_GRAY="$(tput setaf 243)"
else
  # Configure aliases fpr the terminal colors.
  COLOR_LIGHT_BROWN="$(tput setaf 178)"
  COLOR_LIGHT_PURPLE="$(tput setaf 135)"
  COLOR_LIGHT_BLUE="$(tput setaf 87)"
  COLOR_LIGHT_GREEN="$(tput setaf 78)"
  COLOR_LIGHT_YELLOW="$(tput setaf 229)"
  COLOR_YELLOW="$(tput setaf 184)"
  COLOR_GREEN="$(tput setaf 83)"
  COLOR_ORANGE="$(tput setaf 208)"
  COLOR_RED="$(tput setaf 167)"
  COLOR_GRAY="$(tput setaf 243)"
fi

# Helper for showing colors in user specific terminal window+profile.
# Inspired by:
# https://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html
function show_colors {
    python3 <<PYTHON_SCRIPT
import sys
for i in range(0, 16):
    for j in range(0, 16):
        code = str(i * 16 + j)
        sys.stdout.write(u"\u001b[38;5;" + code + "m " + code.ljust(4))
print(u"\u001b[0m")
PYTHON_SCRIPT
}

if [ -e /data/data/com.termux ]; then
  source /data/data/com.termux/files/usr/etc/bash_completion.d/git-prompt.sh
fi

export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto"
# * dirty working, + staged, ? untracked, ! stashed
# = even with remote, < behind remote, > ahead of remote, <> diverged
function git_branch {
  local git_status=$(__git_ps1 "%s")

  if [ -z "$git_status" ]; then
    return 0
  fi

  if [[ "$git_status" == *'*'* ]]; then
    COLOR=$COLOR_RED
  elif [[ "$git_status" == *'+'* ]]; then
    COLOR=$COLOR_RED
  elif [[ "$git_status" == *'%'* ]]; then
    COLOR=$COLOR_RED
  elif [[ "$git_status" == *'!'* ]]; then
    COLOR=$COLOR_RED
  elif [[ "$git_status" == *'?'* ]]; then
    COLOR=$COLOR_RED
  elif [[ "$git_status" == *'#'* ]]; then
    COLOR=$COLOR_YELLOW
  elif [[ "$git_status" == *'>'* ]]; then
    COLOR=$COLOR_YELLOW
  elif [[ "$git_status" == *'<'* ]]; then
    COLOR=$COLOR_YELLOW
  else
    COLOR=$COLOR_LIGHT_GREEN # "=" is clean or even with remote
  fi

  echo -e "$COLOR($git_status) "
}
export -f git_branch


# Fetch the date in a canonical format.
function get_prompt_date {
    echo -e "$COLOR_GRAY$(date +%Y-%m-%d-%H:%M:%S)"
}
export -f get_prompt_date


# Used to use --cidfile and /proc/1/cpuset, but this is what GPT recommended.
function get_docker_ident {
  if [ -f /.dockerenv ] || grep -q 'docker' /proc/1/cgroup 2>/dev/null; then
    # Extract short container ID from /etc/hostname
    echo -e "$COLOR_LIGHT_BROWN($(cat /etc/hostname | cut -c1-12))"
  fi
}
export -f get_docker_ident


function get_k8s_context() {
  local context=$(kubectl config current-context 2>/dev/null)
  if [ -z "$context" ]; then
    return 0
  fi

  echo -e "${COLOR_LIGHT_PURPLE}KC:$context "
}
export -f get_k8s_context


if [ ! -z "$(which kubectl 2>/dev/null)" ]; then
  export KUBECONFIG=$(realpath ~)/node0.yaml
  source <(kubectl completion bash)
  alias kc=kubectl
  complete -o default -F __start_kubectl kc
fi


# Note: Without \[ \] properly placed, wrapping will not work correctly.
# More info found at: https://robotmoon.com/256-colors/
USERHOST_PSENTRY='\[$COLOR_LIGHT_BLUE\]\u\[$COLOR_GRAY\]@\[$COLOR_GREEN\]\h '
PS1="${PS1_TAG}${debian_chroot:+($debian_chroot)}$USERHOST_PSENTRY"
PS1="$PS1\$(get_docker_ident)"
PS1="$PS1\$(get_k8s_context)"
PS1="$PS1\$(git_branch)"
PS1="$PS1\$(get_prompt_date)"
WORKINGDIR='\[$COLOR_LIGHT_YELLOW\]\w'
PROMPT_DELIM='\[$COLOR_RESET\]\$ '
export PS1="$PS1\n$WORKINGDIR$PROMPT_DELIM"

if [ -e "$(realpath ~)/.light_theme" ]; then
  echo -e '\e]12;#004400\a'
else
  echo -e '\e]12;#ffd787\a'
fi

export PATH=~/.local/bin:$PATH
export PROMPT_COMMAND='history -a; echo -ne "\033]2;${HOSTNAME}\007"'
alias myip='curl ifconfig.me'


reload_vscode_ipc() {
  export VSCODE_IPC_HOOK_CLI=$(ls -tr /run/user/$UID/vscode-ipc-* | tail -n 1)
};
shopt -s nullglob
vscode_ipc_files=(/run/user/$UID/vscode-ipc-*)
if (( ${#vscode_ipc_files[@]} )); then
  reload_vscode_ipc
fi


if [ ! -z "$(which lazygit 2>/dev/null)" ]; then
  export LG_CONFIG_FILE="$(lazygit --print-config-dir)/config.yml,$(lazygit --print-config-dir)/theme.yml"
fi


if [ ! -z "$(which vivid 2>/dev/null)" ]; then
  if [ -e "$(realpath ~)/.light_theme" ]; then
    export LS_COLORS="$(vivid generate catppuccin-latte)"
  else
    export LS_COLORS="$(vivid generate catppuccin-mocha)"
  fi
fi


if [ ! -z "$(which zoxide 2>/dev/null)" ]; then
  eval "$(zoxide init bash)"
fi


if [ ! -z "$(which fzf 2>/dev/null)" ]; then
  eval "$(fzf --bash)"
fi


if [ ! -z "$(which bat 2>/dev/null)" ]; then
  eval "$(bat --completion bash)"
fi


#if [ ! -z "$(which rg)" ]; then
#  eval "$(rg --generate complete-bash)"
#fi


if [ ! -z "$(which nvim)" ]; then
  export EDITOR=nvim
  alias vi=nvim
fi


# Note: This one is ugly and messes with my flow.
#if [ ! -z "$(which atuin)" ]; then
#  # Bash command line syntax highlighting.
#  source ~/.local/share/blesh/ble.sh
#  # Enhanced command history.
#  eval "$(atuin init bash)"
#fi


tools() {
  echo 'Git Prompt Legend:'
  echo '  * - unstaged, + - staged, % - untracked, ? - conflict, ! - stashed'
  echo '  # - off-branch, = - with remote, < - behind, > - ahead, <> - diverged'

  echo 'Installed Tools:'
  [ -n "$(which curl 2>/dev/null)" ]       && echo "  myip - get outside IP address"
  [ -n "$(which tmux 2>/dev/null)" ]       && echo "  tmux - terminal multiplexer"
  [ -n "$(which nvim 2>/dev/null)" ]       && echo "  nvim - neovim text editor"
  [ -n "$(which lazygit 2>/dev/null)" ]    && echo "  lazygit - git tui"
  [ -n "$(which lazydocker 2>/dev/null)" ] && echo "  lazydocker - docker tui"
  [ -n "$(which vivid 2>/dev/null)" ]      && echo "  vivid - terminal colors (LS_COLORS)"
  [ -n "$(which kubectl 2>/dev/null)" ]    && echo "  kubectl | kc - K8s CLI"
  # TODO: echo "  kubectl get-all plugin"
  [ -n "$(which btop 2>/dev/null)" ]       && echo "  btop - better top"
  [ -n "$(which k9s 2>/dev/null)" ]        && echo "  k9s - k8s tui manager"
  [ -n "$(which glow 2>/dev/null)" ]       && echo "  glow - markdown reader"
  [ -n "$(which yazi 2>/dev/null)" ]       && echo "  yazi - file manager"
  [ -n "$(which zoxide 2>/dev/null)" ]     && echo "  smart cd (i.e. change directory)"
  [ -n "$(which uv 2>/dev/null)" ]         && echo "  uv - fast rust-based python pkg mgr"
  [ -n "$(which fzf 2>/dev/null)" ]        && echo "  fzf - fuzzy finder (w/ Ctrl-T)"
  [ -n "$(which bat 2>/dev/null)" ]        && echo "  bat - cat with syntax highlighting"
  [ -n "$(which rg 2>/dev/null)" ]         && echo "  rg - modernized grep"
  [ -n "$(which fd 2>/dev/null)" ]         && echo "  fd - modernized find"
  #[ -n "$(which atuin 2>/dev/null)" ]      && echo "  atuin - modernized history"
  [ -n "$(which eza 2>/dev/null)" ]        && echo "  eza - modernized ls"
  [ -n "$(which broot 2>/dev/null)" ]      && echo "  br - file system explorer"
  [ -n "$(which gopass 2>/dev/null)" ]     && echo "  gopass - secret manager"
}


