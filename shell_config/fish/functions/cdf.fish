#!/usr/bin/env fish

function cdf
    set path (fzf)
    if test -n "$path"
        cd (dirname "$path")
    end
end
