#!/usr/bin/env fish

function fish_prompt --description 'Write out the prompt'
    # REGION colors
    set -l whoami_color fd0aff --bold #6AA8F8
    set -l root_color f51130   --bold
    set -l error_color f51130  --bold
    set -l cwd_color 05d900    --bold
    set -l reset_color ffffff  --bold
    # ENDREGION

    set -l last_status $status
    set -l suffix "➜"
    if [ "$USER" = "root" ]
        set suffix "#"
        set whoami_color $root_color
    end

    set_color $whoami_color 
    echo -n (whoami)
    set_color $reset_color
    echo -n '@'(prompt_hostname)' '
    set_color $cwd_color 
    echo -n (prompt_pwd)
    echo -n (git_prompt)

    if not test $last_status -eq 0
        set_color $error_color 
        echo -n ' ['
        echo -n (fish_status_to_signal $last_status)
        echo -n ']'
    end
    
    set_color $reset_color
    echo -n ' '$suffix' '
    set_color normal
end

function git_prompt --description 'Write out the git prompt'
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        # REGION colors
        set -l git_blue 0d0dff    --bold #set_color 1414f7
        set -l error_color f51130 --bold
        set -l grey_color 6c6c6c   --bold
        set -l yelllow_color f5f511 --bold
        # ENDREGION

        set_color $git_blue
        echo -n " git:("
        set_color $error_color 
        # <-- echo -n (git branch --show-current) -->

        if not git diff --quiet || not git diff --cached --quiet
            #echo -n '*'
            set_color $yelllow_color
        end
        echo -n (git branch --show-current)
        
        set_color $git_blue
        echo -n ")"
        set_color normal
    end
end