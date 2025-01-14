#!/usr/bin/env fish

function last_status -d 'Write out the $status'
    set -l last_status $status
    set_color $fish_color_error
    echo -n "["
    echo -n (fish_status_to_signal $last_status)
    echo "]"
end