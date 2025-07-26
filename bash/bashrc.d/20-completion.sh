# Bash completion setup
# This module handles git completion and other completion features

# Only run if we're in an interactive shell
case $- in
    *i*)
        # Load git completion if not already available system-wide
        if ! test -f /usr/local/etc/bash_completion.d/git-completion.bash; then
            . "$ETC_HOME/bash/git-completion.bash"
        fi
        ;;
esac