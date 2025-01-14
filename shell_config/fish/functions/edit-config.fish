#!/usr/bin/env fish

function edit-config -d "Edit the $HOME/.config/fish/config.fish file"
    code $HOME/.config/fish/config.fish
end