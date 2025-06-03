## Start ssh-agent if not running
#if [ -z "$SSH_AUTH_SOCK" ] || ! ps -p "$SSH_AGENT_PID" > /dev/null 2>&1; then
#  eval "$(ssh-agent -s)"
#  ssh-add ~/.ssh/id_rsa 2>/dev/null
#fi

# Start ssh-agent if not already running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval "$(ssh-agent -s)" > /dev/null
fi

# Add your key if not already loaded
ssh-add -l > /dev/null 2>&1 || ssh-add ~/.ssh/id_rsa
