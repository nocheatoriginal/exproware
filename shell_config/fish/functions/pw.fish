#!/usr/bin/env fish

function pw -d 'Copy the current working directory to the clipboard and print it to the terminal.'
    echo -n (pwd) | pbcopy
    echo (pwd)
end