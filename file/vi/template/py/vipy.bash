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

do_extra(){
    num_wc=$(wc -l "$fpath_new")
    num_line=${num_wc%% *}
    #echo "num_line: $num_line"
    
    if [ $num_line -le 1 ]
        then
        echo "ERR:: Line Number: Less or equal to 1."
        return 1
    fi

    line_utf8='# -*- coding: utf-8 -*-'
    sed "2i $line_utf8\n" -i "$fpath_new"
}

wrap_vi(){
    wrap_touch "$@"
    vi "$fpath_new" +4
}

wrap_vi "$@"
