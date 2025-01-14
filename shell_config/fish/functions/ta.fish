#!/usr/bin/env fish

function ta -d "tmux a" -a target
    if not tmux has-session -t dev 2>/dev/null
        tn dev
        return 0
    end

    if test -n "$target"
        tmux a -t $target
    else
        tmux a
    end
end