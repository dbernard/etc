if [ "$platform" = 'darwin' ]; then
    alias du='du -h -d1'
    alias ps='ps auxww'
    alias ls='ls -hFGAO'
    alias ll='ls -l'
    alias top='top -o cpu -i 1'
    alias eject='diskutil eject'
fi

_grep_color="--color=auto"
_grep_extra="$_grep_color -s"

alias grep="grep $_grep_extra"
alias ngrep="grep -n $_grep_extra"
alias egrep="egrep $_grep_extra"
alias negrep="egrep -n $_grep_extra"
alias hgrep="history | grep $_grep_extra"

unset _grep_extra

_has_executable colordiff &&
    {
        function diff()
        {
            if test -t 1
            then
                "$(_find_executable diff)" "$@" | colordiff | $PAGER
            else
                "$(_find_executable diff)" "$@"
            fi
        }

        function interdiff()
        {
            if test -t 1
            then
                "$(_find_executable interdiff)" "$@" | colordiff | $PAGER
            else
                "$(_find_executable interdiff)" "$@"
            fi
        }
    }

# Neovim alias
alias nv="nvim"

# Codespaces SSH alias
alias ghcs="gh cs ssh --server-port 2222"
