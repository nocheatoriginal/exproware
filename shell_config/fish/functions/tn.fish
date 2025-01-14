#!/usr/bin/env fish

function tn -d "tmux new -s" -a session
    tmux new -s $session
end