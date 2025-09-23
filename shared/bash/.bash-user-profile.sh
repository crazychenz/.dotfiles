
if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
    # Do GUI only things.
else
    # Do console only things.

    # Start ssh-agent if not already running
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
      eval "$(ssh-agent -s)" > /dev/null
    fi

    # Add our ssh key to agent.
    ssh-add -l > /dev/null 2>&1 || ssh-add ~/.ssh/id_rsa
fi
