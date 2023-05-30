if [ "$platform" = 'darwin' ]; then
    alias du='du -h -d1'
    alias ps='ps auxww'
    alias ls='ls -hFGAO'
    alias ll='ls -l'
    alias top='top -o cpu -i 1'
    alias eject='diskutil eject'
fi

if [ "$platform" = 'linux' -o "$platform" == 'mingw' ]; then
    alias du='du -bh --max-depth=1'
    alias ps='ps -efww'
    alias ls='ls -hFA --color=auto'
    alias ll='ls -l'
    alias top='top -d 1'
    if _has_executable xsel; then
        alias pbcopy='xsel --clipboard --input'
        alias pbpaste='xsel --clipboard --output'
    elif _has_executable xclip; then
        alias pbcopy='xclip -selection clipboard'
        alias pbpaste='xclip -selection clipboard -o'
    fi
    if _has_executable xdg-open; then
        alias open="xdg-open"
    elif [[ "$DESKTOP_SESSION" == "gnome" ]]; then
        alias open="gnome-open"
    elif [[ "$DESKTOP_SESSION" == "kde" ]]; then
        alias open="kde-open"
    else
        # Default to xdg open... it'll at least remind me to install
        # xdg-utils (or the equivalent).
        alias open="xdg-open"
    fi
fi


_grep_color="--color=auto"

# Don't descend into Subversion's admin area, or others like it.
# Mac's bsd grep sucks... so there's no easy way to do this.
# Also, suppress error messages.
if [[ "$platform" == 'linux' ]]; then
    _grep_extra="$_grep_color -s --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.bzr --exclude=tags"
else
    _grep_extra="$_grep_color -s"
fi

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

alias wget="wget --no-check-certificate"
alias wget-ff='wget --user-agent="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:11.0) Gecko/20100101 Firefox/11.0"'

alias netcat=nc

# rvm-related
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    # yes, this essentially replaces the system gem... but I like to install
    # libraries for me, and not f-up my entire system.
    alias gem="rvm gem"
    alias compass="rvm exec compass"
    alias rake="rvm rake"
fi

# Neovim alias
alias nv="nvim"

# Codespaces SSH alias
alias ghcs="gh cs ssh --server-port 2222"
