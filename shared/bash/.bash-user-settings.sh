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
  if [ -f /.dockerenv ] || grep -q 'docker' /proc/1/cgroup; then
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


if [ ! -z "$(which kubectl)" ]; then
  export KUBECONFIG=$(realpath ~)/node0.yaml
  source <(kubectl completion bash)
  alias kc=kubectl
  complete -o default -F __start_kubectl kc
fi


# Note: Without \[ \] properly placed, wrapping will not work correctly.
# More info found at: https://robotmoon.com/256-colors/
USERHOST_PSENTRY='\[$COLOR_LIGHT_BLUE\]\u\[$COLOR_GRAY\]@\[$COLOR_GREEN\]\h '
PS1="${debian_chroot:+($debian_chroot)}$USERHOST_PSENTRY"
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
export EDITOR=nvim
export PROMPT_COMMAND='history -a'
alias myip='curl ifconfig.me'


reload_vscode_ipc() {
  export VSCODE_IPC_HOOK_CLI=$(ls -tr /run/user/$UID/vscode-ipc-* | tail -n 1)
};
shopt -s nullglob
vscode_ipc_files=(/run/user/$UID/vscode-ipc-*)
if (( ${#vscode_ipc_files[@]} )); then
  reload_vscode_ipc
fi


if [ ! -z "$(which lazygit)" ]; then
  export LG_CONFIG_FILE="$(lazygit --print-config-dir)/config.yml,$(lazygit --print-config-dir)/theme.yml"
fi


if [ ! -z "$(which vivid)" ]; then
  if [ -e "$(realpath ~)/.light_theme" ]; then
    export LS_COLORS="$(vivid generate catppuccin-latte)"
  else
    export LS_COLORS="$(vivid generate catppuccin-mocha)"
  fi
fi


if [ ! -z "$(which zoxide)" ]; then
  eval "$(zoxide init bash)"
fi


if [ ! -z "$(which fzf)" ]; then
  eval "$(fzf --bash)"
fi


if [ ! -z "$(which bat)" ]; then
  eval "$(bat --completion bash)"
fi


#if [ ! -z "$(which rg)" ]; then
#  eval "$(rg --generate complete-bash)"
#fi


if [ -z "\$(ldd --version | grep -i -e gnu -e glibc)" ]; then
  export PATH=$(realpath ~)/.local/nvim-linux64/bin:${PATH}
else
  export PATH=$(realpath ~)/.local/nvim-linux64-glibc/bin:${PATH}
fi


tools() {
  echo 'Git Prompt Legend:'
  echo '  * - unstaged, + - staged, % - untracked, ? - conflict, ! - stashed'
  echo '  # - off-branch, = - with remote, < - behind, > - ahead, <> - diverged'

  echo 'Installed Tools:'
  [ -n "$(which tmux)" ]    && echo "  tmux - terminal multiplexer"
  [ -n "$(which nvim)" ]    && echo "  nvim - neovim text editor"
  [ -n "$(which lazygit)" ] && echo "  lazygit - git tui"
  [ -n "$(which vivid)" ]   && echo "  vivid - terminal colors (LS_COLORS)"
  [ -n "$(which kubectl)" ] && echo "  kubectl | kc - K8s CLI"
                              #echo "  kubectl get-all plugin"
  [ -n "$(which btop)" ]    && echo "  btop - better top"
  [ -n "$(which k9s)" ]     && echo "  k9s - k8s tui manager"
  [ -n "$(which glow)" ]    && echo "  glow - markdown reader"
  [ -n "$(which yazi)" ]    && echo "  yazi - file manager"
  [ -n "$(which zoxide)" ]  && echo "  smart cd (i.e. change directory)"
  [ -n "$(which uv)" ]      && echo "  uv - fast rust-based python pkg mgr"
  [ -n "$(which fzf)" ]     && echo "  fzf - fuzzy finder (w/ Ctrl-T)"
  [ -n "$(which bat)" ]     && echo "  bat - cat with syntax highlighting"
}


