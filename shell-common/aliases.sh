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

# Hack for codespace setup
alias srcweb="source /workspaces/web/venv/bin/activate && source /workspaces/web/profile && source /workspaces/web/profile-codespaces"

# Open the newest Monday Group Brief in the browser.
#
# Re-renders first when viewer/ is missing or older than the newest brief:
# viewer/ is gitignored (so a fresh clone has none), and the weekly run treats a
# render failure as non-fatal on purpose — the brief still lands and still posts
# to Slack — so opening a stale viewer is a normal thing to walk into.
function brief()
{
    local repo="$HOME/projects/staff-eng-brief"
    local index="$repo/viewer/index.html"
    local newest

    # Brief filenames are ISO dates, so the last one lexically is the newest.
    newest="$(ls -1 "$repo"/briefs/*.md 2>/dev/null | tail -1)"

    if [ -z "$newest" ]
    then
        echo "brief: no briefs found in $repo/briefs" >&2
        return 1
    fi

    if [ ! -f "$index" ] || [ "$newest" -nt "$index" ]
    then
        echo "brief: viewer is stale, rendering..." >&2
        bash "$repo/scripts/render.sh" >&2 || return 1
    fi

    open "$index"
}
