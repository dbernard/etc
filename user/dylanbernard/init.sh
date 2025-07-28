 #!/bin/bash

target="$ETC_HOME/user/$ETC_USER/coffee.sh"

if [ -f "$target" ]; then
    alias coffee="bash \"$target\""
fi
