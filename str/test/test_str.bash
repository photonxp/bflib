#!/bin/bash

spath=$(realpath "$0")
swd=${spath%/*}
source "$swd"/testf.bashlib
source "$swd"/../str.bashlib

test_chk_empty_str(){
    chk_empty_str ""
    assert_equal_num 1 "$?"  

    chk_empty_str "a"
    assert_equal_num 0 "$?"  
}

test_get_str_length(){
    length=$(get_str_length "abc")
    assert_equal_num 3 "$length"  
    length=$(get_str_length "")
    assert_equal_num 0 "$length"  
}

test_chk_str_start_idx(){
    rslt=$(chk_str_start_idx 1 -1 0)
    assert_equal_num 1 $?
    assert_in_str "Start idx: -1 is less than 0" "$rslt"

    rslt=$(chk_str_start_idx 1 0 0)
    assert_equal_num 0 $?

    rslt=$(chk_str_start_idx 2 2 2)
    assert_equal_num 1 $?
    assert_in_str "Start idx: 2 is larger than str idx upper limit 1" "$rslt"

    rslt=$(chk_str_start_idx 2 1 1)
    assert_equal_num 0 $?
}

test_chk_str_end_idx(){
    rslt=$(chk_str_end_idx 3 0 -1)
    assert_in_str "End idx: -1 is less than 0" "$rslt"

    rslt=$(chk_str_end_idx 3 0 3)
    assert_equal_num 1 $?
    assert_in_str "End idx: 3 is larger than str idx upper limit 2" "$rslt"

    rslt=$(chk_str_end_idx 3 0 0)
    assert_equal_num 0 $?

    rslt=$(chk_str_end_idx 3 0 2)
    assert_equal_num 0 $?

    rslt=$(chk_str_end_idx 3 2 1)
    assert_equal_num 1 $?
    assert_in_str "End idx: 1 is less than start idx 2 ." "$rslt"

    rslt=$(chk_str_end_idx 3 2 2)
    assert_equal_num 0 $?
}

test_get_substr_by_start_end(){
    rslt=$(get_substr_by_start_end "" -1 2)
    assert_equal_num "1" $?
    assert_in_str "Str: Length is 0" "$rslt"

    rslt=$(get_substr_by_start_end "abc" -1 2)
    assert_equal_num "1" $?
    assert_in_str "Start idx: -1 is less than 0" "$rslt"

    rslt=$(get_substr_by_start_end "abc" 0 2)
    assert_equal_str "abc" $rslt

    rslt=$(get_substr_by_start_end "abc" 1 -1)
    assert_equal_num "1" $?
    assert_in_str "End idx: -1 is less than 0" "$rslt"

    rslt=$(get_substr_by_start_end "abc" 0 0)
    assert_equal_str "a" "$rslt"

    rslt=$(get_substr_by_start_end "abc" 2 2)
    assert_equal_str "c" "$rslt"

    rslt=$(get_substr_by_start_end "abc" 4 3)
    assert_in_str "Start idx: 4 is larger than str idx upper limit 2" "$rslt"
}

test_chk_str_idx(){
    rslt=$(chk_str_idx 1 -1)
    assert_equal_num "1" $?
    assert_in_str "idx: -1 is less than 0" "$rslt"

    rslt=$(chk_str_idx 1 1)
    assert_equal_num "1" $?
    assert_in_str "idx: 1 is larger than str idx upper limit 0" "$rslt"

    rslt=$(chk_str_idx 1 0)
    assert_equal_num 0 $?

    rslt=$(chk_str_idx 3 2)
    assert_equal_num 0 $?
}

test_get_char_by_idx(){
    rslt=$(get_char_by_idx "" 0)
    assert_equal_num "1" $?
    assert_in_str "ERR:: Str: Length is 0" "$rslt"

    rslt=$(get_char_by_idx "a" -1)
    assert_equal_num "1" $?
    assert_in_str "ERR:: idx: -1 is less than 0" "$rslt"

    rslt=$(get_char_by_idx "a" 1)
    assert_equal_num "1" $?
    assert_in_str "ERR:: idx: 1 is larger than str idx upper limit 0" "$rslt"

    rslt=$(get_char_by_idx "a" 0)
    assert_equal_str "a" "$rslt"

    rslt=$(get_char_by_idx "ba" 1)
    assert_equal_str "a" "$rslt"
}

test_str2arr(){
    str2arr ""
    assert_equal_num 1 $?

    #str2arr "abc"
    str2arr "abc"
    arr=$(str2arr "abc")
    assert_equal_num 0 $?
    echo "arr: $arr"
    echo "${!arr}"
}

test_str_do_iter(){
    fun1(){
        echo "hello"
    }

    rslt=$(str_do_iter "ab" "fun1")
    #expt="hello\\\\nhello\\\\n"
    expt="hello\\\\n"
    assert_in_str "$expt" "$rslt"
}

test_xstr(){
    rslt=$(xstr "abc" "ab")
    assert_in_str "a b" "$rslt"
    rslt=$(xstr "efj" "fjk")
    assert_in_str "f j" "$rslt"
}

opt="-o"
tests1="test_chk_empty_str test_get_str_length"
tests2="test_chk_str_start_idx test_chk_str_end_idx test_get_substr_by_start_end test_chk_str_idx test_get_char_by_idx"
tests3="test_str_do_iter test_xstr"
tests="$tests1 $tests2 $tests3"
run_tests "test_str2arr"
#run_tests $tests
