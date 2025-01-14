#!/usr/bin/env fish
function music -d "Spielt Musik in dem Terminal" --argument file
    $HOME/dotfiles/home/utils/music/music.sh $file
end
