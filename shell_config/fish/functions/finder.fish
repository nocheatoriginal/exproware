#!/usr/bin/env fish

function finder -d 'Open finder.app at current folder'
    if test -z $argv[1]
        open .
        return 0
    end

    if test -e $argv[1]
        open -R $argv[1]
        return 0
    end
    return 1
end