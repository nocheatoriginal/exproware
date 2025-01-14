#!/usr/bin/env fish

function gradle -d "Run gradle-wrapper if exists else run local gradle installation"
    if test -f ./gradlew
        ./gradlew $argv
    else
        command gradle $argv
    end
end
