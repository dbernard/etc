#!/bin/bash

cd $(dirname $0)

# If the path is under HOME, then make it relative
PATH_TO_ETC=${PWD/$HOME\//}
ETC_HOME=${PWD/$HOME\//\$HOME\/}
TILDE_ETC_HOME=${PWD/$HOME\//~\/}

if [ "$PATH_TO_ETC" != "projects/etc" ]; then
    SET_ETC_HOME="ETC_HOME=\"$ETC_HOME\""
    SOURCE_PREFIX="\$ETC_HOME"
else
    SET_ETC_HOME=""

    # Use ETC_HOME as the source prefix because the shell may be coming up in
    # a directory other than home.  This is common in Fedora, where a new
    # terminal will start you in the current working directory.
    SOURCE_PREFIX="$ETC_HOME"
fi

# Record the date and time for backups
save_date=$(date "+%Y%m%d-%H%M%S")

_backupFile() {
    local origFile="$1"
    local newFile="$origFile.$save_date"

    test -e "$origFile" &&
        mv "$origFile" "$newFile" &&
        echo "Saved old '$origFile' as '$newFile'"

    return 0
}

_maybeInstall() {
    local s="$1"
    local file="$2"
    local base=$(basename "${file}")

    echo "Checking ${base}..."

    (test -e "$file" && grep -F -x -q "${s}" "$file") ||
        (_backupFile "$file" &&
         ((test -n "$SET_ETC_HOME" && echo "$SET_ETC_HOME" > "$file") ||
          : > "$file") &&
         echo "$s" >> "$file" &&
         echo "Installed $base")
    return 0
}

_maybeAppend() {
    local s="$1"
    local file="$2"
    local base=$(basename "${file}")

    echo "Checking ${base}..."

    # Check if our source line already exists
    if test -e "$file" && grep -F -x -q "${s}" "$file"; then
        echo "$base already configured"
        return 0
    fi

    # Create file if it doesn't exist, or append to existing file
    if test ! -e "$file"; then
        # File doesn't exist, create it
        if test -n "$SET_ETC_HOME"; then
            echo "$SET_ETC_HOME" > "$file"
        fi
        echo "$s" >> "$file"
        echo "Created $base"
    else
        # File exists, append our configuration
        echo "" >> "$file"  # Add blank line for separation
        if test -n "$SET_ETC_HOME"; then
            echo "$SET_ETC_HOME" >> "$file"
        fi
        echo "$s" >> "$file"
        echo "Updated $base"
    fi
    return 0
}

_installLink() {
    local name
    name="$(basename "$1")"
    [[ -n "$3" ]] && name="$3"
    echo "Checking $name..."
    test ! -e "$1" && \
        ln -s "$PATH_TO_ETC/$2" "$1" &&
        echo "Installed $name"
}

# Set up links to configuration bits

_installLink "$HOME/.inputrc" inputrc/inputrc
_installLink "$HOME/.tmux.conf" tmux/tmux.conf
_installLink "$HOME/.colordiffrc" colordiffrc/colordiffrc

echo "Checking .gitconfig..."
test ! -e "$HOME/.gitconfig" &&
    echo "\
[include]
	path = $TILDE_ETC_HOME/gitconfig/gitconfig

[core]
	excludesfile = $TILDE_ETC_HOME/gitconfig/gitignores
" > "$HOME/.gitconfig" &&
    echo "Installed .gitconfig" &&
    echo 'Run the following to set the git user name:
    git config --global user.name "User Name"' &&
    echo 'Run the following to set the git user email:
    git config --global user.email "user@example.com"'

if [ "$(uname)" == "Darwin" ]; then
    _installLink "$HOME/.editrc" editrc/editrc
    mkdir -p $HOME/Library/Fonts &&
        cp fonts/*.ttf $HOME/Library/Fonts &&
        echo "Installed custom fonts"
fi

if [ "$(uname)" == "Linux" ]; then
    mkdir -p $HOME/.fonts &&
        cp fonts/*.ttf $HOME/.fonts &&
        echo "Installed custom fonts"
fi

if [ "$(uname)" == "Darwin" ]; then
    # Under Mac OS X, it opens login shells, and the default /etc/bashrc doesn't
    # source the user's ~/.bashrc.
    if ! test -r "$HOME/.bash_profile"; then
        echo '[ -r ~/.bashrc ] && . ~/.bashrc' > ~/.bash_profile
    fi
fi

_maybeAppend "source \"$SOURCE_PREFIX/bash/bashrc\"" "$HOME/.bashrc"
