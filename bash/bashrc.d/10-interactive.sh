# Interactive shell configuration
# This module handles setup that only applies to interactive shells

# Only run if we're in an interactive shell
case $- in
    *i*)
        # Load interactive shell configuration
        . "$ETC_HOME/shell-common/interactive.sh"
        . "$ETC_HOME/bash/shell-options.sh"
        ;;
esac