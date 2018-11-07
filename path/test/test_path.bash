#!/bin/bash

fpath=$(realpath "$0")
swd=${fpath%/*}

source "$swd"/testf.bashlib
source "$swd"/../path.bashlib

test_is_sfx_fname(){
    is_sfx_fname "a.bash"
    assert_equal_num 0 $?
    is_sfx_fname "bash"
    assert_equal_num 1 $?
}

test_get_fname_by_path(){
    fname=$(get_fname_by_path "a/b/c")
    assert_equal_str "c" "$fname"
}

test_get_fname_by_spath(){
    sname=$(get_fname_by_spath)
    assert_equal_str "test_path.bash" "$sname"
}

test_get_sfx_by_fname(){
    sfx=$(get_sfx_by_fname "a.bash")
    assert_equal_str "bash" "$sfx"
    sfx=$(get_sfx_by_fname "bash")
    assert_equal_str "" "$sfx"
}

test_get_nosfx_by_fname(){
    nosfx=$(get_nosfx_by_fname "a.bash")
    assert_equal_str "a" "$sfx"
    nosfx=$(get_nosfx_by_fname "bash")
    assert_equal_str "bash" "$sfx"
}

test_get_sfx_by_spath(){
    sfx=$(get_sfx_by_spath)
    assert_equal_str "bash" "$sfx"
}

test_chk_fname_by_sfx(){
    chk_fname_by_sfx "a.bash" "bash"
    assert_equal_num 0 $?
    chk_fname_by_sfx "a" "bash"
    assert_equal_num 1 $?
    chk_fname_by_sfx "bash" "bash"
    assert_equal_num 1 $?
}

test91(){
    chk_fname_by_sfx "a.bash" "bash"
    assert_equal_num 0 $?
}

opt="-o"
tests="test_is_sfx_fname test_get_fname_by_path test_get_fname_by_spath test_get_sfx_by_fname test_get_sfx_by_spath test_chk_fname_by_sfx"
run_tests `echo $tests`

