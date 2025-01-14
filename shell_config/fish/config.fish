#!/usr/bin/env fish

if status is-interactive
end

alias manpath=false
export NVM_DIR=~/.nvm

set -g fish_greeting
source $HOME/.config/fish/aliases.fish

function handle_sigint --on-signal SIGINT
    echo ""
    commandline -f repaint
    return 1
end
