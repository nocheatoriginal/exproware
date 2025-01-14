#!/usr/bin/env fish

function weather -d "Stellt das aktuelle Wetter in dem Terminal dar" --argument Ort
    set default_ort Heilbronn
    if test -z $Ort
        set Ort $default_ort
    end

    if ping -c 1 google.com > /dev/null 2>&1
        curl -s "wttr.in/$Ort?0"
    else
        return 1
    end
end
