#!/bin/bash

# The limits of my code are the limits of my mode -- Wittpunstein

# Features
# Automatically generates bashfile for the given file name without file suffix
# shebang is added too

# Usage:
# vibash ./test9/a
#     will generate ./test9/a.bash in the vi editor

fpath=$(realpath "$0")
swd=${fpath%/*}
source "$swd/touchshell.bashlib"
source "$swd/path.bashlib"

wrap_vi(){
    wrap_touch "$@"
    vi "$fpath_new" +3
}

wrap_vi "$@"
