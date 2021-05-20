export ROVER_HOME=$HOME/projects/web/src/aplaceforrover/

if [ -d "$ROVER_HOME" ]; then
    alias web='cd "$ROVER_HOME"'
fi
