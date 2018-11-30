#!/bin/bash


spath=$(realpath "$0")
swd=${spath%/*}
source "$swd"/escape.bashlib
source "$swd"/array.bashlib
source "$swd"/testf.bashlib

opt="-o"

test_char_escape(){
    escape_list='$ z'
    chars_new=$(char_escape '$' "$escape_list")
    [ '\$' == "$chars_new" ] && echo Pass || echo Fail 

    escape_list='z $'
    chars_new=$(char_escape '$' "$escape_list")
    [ '\$' == "$chars_new" ] && echo Pass || echo Fail
}

test_escape(){
    escape_list='$ z'
    str_new=$(escape '$' "$escape_list")
    printf '%s' "$str_new"
    echo
    [ '\$' == "$str_new" ] && echo Pass || echo Fail

    escape_list='$ +'
    str_new=$(escape '$+' "$escape_list")
    [ '\$\+' == "$str_new" ] && echo Pass || echo Fail

    escape_list='\'
    str_new=$(escape '\\\\' "$escape_list")
    [ '\\\\\\\\' == "$str_new" ] && echo Pass || echo Fail

    escape_list='\'
    str_new=$(escape '\n' "$escape_list")
    [ '\\n' == "$str_new" ] && echo Pass || echo Fail
}

#run_tests "test_char_escape"
#run_tests "test_escape"
run_tests "test_char_escape test_escape"
