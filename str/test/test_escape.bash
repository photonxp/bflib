#!/bin/bash


spath=$(realpath "$0")
swd=${spath%/*}
source "$swd"/escape.bashlib
source "$swd"/array.bashlib
source "$swd"/testf.bashlib

opt="-o"

test_char_escape(){
    escape_list="$ z"
    rslt=$(char_escape "$" "$escape_list")
    echo "$rslt"

    escape_list="z $"
    rslt=$(char_escape "$" "$escape_list")
    echo "$rslt"
}

test_escape(){
    escape_list="$ z"
    rslt=$(escape "$" "$escape_list")
    echo "$rslt"

    escape_list="$ +"
    rslt=$(escape "$+" "$escape_list")
    echo "$rslt"
}

run_tests "test_escape"
#run_tests "test_char_escape"
