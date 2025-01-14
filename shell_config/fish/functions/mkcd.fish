#!/usr/bin/env fish

function mkcd -d 'Make directory and cd to that directory' -a path
    mkdir -p "$path"; and cd "$path"
end
