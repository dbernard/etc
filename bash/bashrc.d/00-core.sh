# Core environment setup and essential functions
# This module provides the fundamental environment setup that other modules depend on

# Set up ETC_HOME and ETC_USER variables
ETC_HOME="${ETC_HOME:-$HOME/projects/etc}"

if [ -z "$ETC_USER" ]; then
    case "$(uname)" in
        MING*)
            ETC_USER="$USERNAME"
            ;;
        *)
            ETC_USER="$(whoami)"
            ;;
    esac
fi

# Needed for some color-related bits
_start_ansi="\["
_end_ansi="\]"

# A function to help with creating directory aliases and providing
# completion for them.
# Taken from here:
#   http://blog.caioromao.com/2010/10/10/Custom-directory-completion.html
# Tweaked to work with more than just 'cd'
function _make_dir_complete()
{
    local aliasname=$1
    local prgname="__s_${aliasname}__"

    cd "$3" >/dev/null 2>&1
    local dirname=$(pwd -L)
    local realpath=$(pwd -P)
    cd - >/dev/null 2>&1

    FUNC="function $prgname()
    {
        local cur len wrkdir;
        local IFS=\$'\\n'
        wrkdir=\"$realpath\"
        cur=\${COMP_WORDS[COMP_CWORD]};
        len=\$((\${#wrkdir} + 2));
        COMPREPLY=( \$(compgen -S/ -d \$wrkdir/\$cur| cut -b \$len-) );
    }"
    ALIAS="$aliasname () { $2 \"$dirname/\$*\"; }"

    eval $FUNC
    eval $ALIAS
    complete -o nospace -F $prgname $aliasname
}

function _find_executable()
{
    type -P "$@"
}

# Load non-interactive shell configuration
. "$ETC_HOME/shell-common/noninteractive.sh"