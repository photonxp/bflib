#!/bin/bash

fpath=$(realpath "$0")
swd=${fpath%/*}

source "$swd"/array.bashlib
source "$swd"/str.bashlib
source "$swd"/escape.bashlib
source "$swd"/testf.bashlib

test_arr2str(){
    arr=("a b" '\\' "c d")
    # 1st arg is "str_arg_name"
    #arr2str "str" "arr[@]"
    str=$(arr2str "arr[@]")
    [ 'a b\\c d' == "$str" ] && echo Pass || echo Fail
}

test_get_arr_length(){
    # doesn't work

    # quirk
    # impossible to pass empty str to function
    l=$(get_arr_length "")
    assert_equal_num 0 "$l"

    l=$(get_arr_length a)
    assert_equal_num 0 "$l"

    unset arr
    arr=()
    l=$(get_arr_length arr[@])
    assert_equal_num 0 "$l"

    # quirk. impossible to pass "" as var or arg
    str=""
    arr=($str)
    l=$(get_arr_length arr[@])
    assert_equal_num 0 "$l"

    # quirk. impossible to pass ("") as var or arg
    arr=("")
    l=$(get_arr_length arr[@])
    assert_equal_num 0 "$l"

    arr=("a")
    l=$(get_arr_length arr[@])
    assert_equal_num 1 "$l"

    arr=("a" "b" "" "c")
    l=$(get_arr_length arr[@])
    assert_equal_num 3 "$l"
}

test_arr_do_iter(){
    fun1(){
        echo "hello"
    }

    arr=("a" "b")
    rslt=$(arr_do_iter arr[@] "fun1")
    assert_in_str `printf "hello\nhello\n"` "$rslt"
}

test_arr_intersect_do(){
    fun1(){
        echo "$1"
    }


    arr1=("a" "b" "c")
    arr2=("b" "c" "d")
    rslt=$(arr_intersect_do arr1[@] arr2[@] "fun1")
    expt=$(printf "b\nc\n")
    assert_in_str "$expt" "$rslt"

    arr1=("e" "f" "j")
    arr2=("f" "j" "k")
    rslt=$(arr_intersect_do arr1[@] arr2[@] "fun1")
    expt=$(printf "f\nj\n")
    assert_in_str "$expt" "$rslt"

    arr1=("e" "f" "j")
    arr2=("f" "j" "k")
    rslt=$(arr_intersect_do arr1[@] arr2[@] ":")
}

opt="-o"
tests1="test_get_arr_length"
tests2="test_arr_do_iter test_arr_intersect_do"
tests="$tests1 $tests2"
run_tests "test_arr2str"
#run_tests `echo "$tests"`
