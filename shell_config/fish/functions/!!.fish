#!/usr/bin/env fish

function !! -d "Insert last command"
  echo $history[1]
end
