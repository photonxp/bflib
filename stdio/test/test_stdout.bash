#!/bin/bash


spath=$(realpath "$0")
swd=${spath%/*}
source "$swd"/stdout.bashlib
source "$swd"/escape.bashlib
source "$swd"/str.bashlib
source "$swd"/testf.bashlib

opt="-o"

test_printfnewlns(){
    printfnewlns 3
}

test_printfln(){
    printfln "ab"
}

test_printf_raw(){
    printf_raw "\ \t" "$ESCAPE_LIST_PRINTF"
    echo
    printf_raw "\ " "$ESCAPE_LIST_PRINTF"
}

run_tests "test_printf_raw"
#run_tests "test_printfnewlns test_printfln"
