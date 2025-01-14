#!/usr/bin/env fish

function zip-master -d "Zip master solution"
    set folder (string match -r "$HOME/Desktop/HHN/Tutor/asb-kprog-22-ws/[^/]+" (pwd))
    if not test -n "$folder"
        return 1
    end
    set name (basename $folder)
    cd $folder/src/main/java/
    zip -r $name-solution.zip prog/
end
