# Theme and prompt configuration
# This module handles the bash theme/prompt setup

# Only run if we're in an interactive shell
case $- in
    *i*)
        # Load the bash theme
        source "$ETC_HOME/bash/themes/${BASH_THEME:-dbernard}.bash-theme"
        ;;
esac