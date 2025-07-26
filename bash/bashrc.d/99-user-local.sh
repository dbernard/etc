# User-specific local configuration
# This module loads any user-specific customizations

# Only run if we're in an interactive shell
case $- in
    *i*)
        # Load user-specific initialization if it exists
        test -f "$ETC_HOME/user/$ETC_USER/init.sh" &&
            . "$ETC_HOME/user/$ETC_USER/init.sh"
        ;;
esac