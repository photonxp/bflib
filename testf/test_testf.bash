#!/bin/bash


fpath=$(realpath "$0")
swd=${fpath%/*}

source $swd/testf.bashlib

init_test_extra(){
    d_l1="$dpath_test/d_l1"
    d_t1="$dpath_test/d_t1"
    [ -e "$d_l1" ] && rm -r "$d_l1"
    [ -e "$d_t1" ] && rm -r "$d_t1"
    mkdir "$d_l1" "$d_t1"
}

test_hello(){
    echo "hello world"
}

test_init_dir_unexist(){
    opt="-o"
    [ -e ./test9 ] && rm -r ./test9
    init_dir
    rslt="$(ls -d ./test9)"
    assert_equal_str "./test9" "$rslt"
}

test_init_dir_exist_no_op(){
    opt=""
    [ ! -e ./test9 ] && mkdir ./test9
    rslt=$(init_dir)
    n_words=$(get_first_n_words_by_space "$rslt" 3)
    assert_equal_str "Cannot create dir::" "$n_words"
    opt="-o"
}

test_init_dir_exist_op(){
    [ ! -e ./test9 ] && mkdir ./test9
    opt="-o"
    rslt=$(init_dir)
    assert_equal_str "" "$rslt"
}

test_assert_equal_str_raw(){
    assert_equal_str_raw '\n' '\n'
    assert_equal_str_raw "" ""
}

test_assert_equal_str(){
    assert_equal_str "a" "a"
    assert_equal_str 1 1
    assert_equal_str "" ""
    assert_equal_str '' ""
    assert_equal_str ''
    
    rslt=$(assert_equal_str "a" "b")
    n_words=$(get_first_n_words_by_space "$rslt" 1)
    printf "$rslt" | grep -Eq "Fail:"
    assert_equal_str "0" "$?"
}

test_assert_equal_num(){   
    assert_equal_num 1 1
    assert_equal_num "1" "1"

    rslt=$(assert_equal_num "" "")
    printf "$rslt" | grep -Eq "Expt: expected is empty, Actl: actual is empty"
    assert_equal_str "0" "$?"

    rslt=$(assert_equal_num "" 1)
    printf "$rslt" | grep -Eq "Expt: expected is empty"
    assert_equal_str "0" "$?"

    rslt=$(assert_equal_num 1 "")
    printf "$rslt" | grep -Eq "Actl: actual is empty"
    assert_equal_str "0" "$?"

    rslt=$(assert_equal_num 1 2)
    printf "$rslt" | grep -Eq "Fail: '1' != '2'"
    assert_equal_str "0" "$?"
    
    rslt=$(assert_equal_num "a" "a")
    assert_equal_str "2" "$?"
    printf "$rslt" | grep -Eq "Miscellaneous Err: retcode '2'"
    assert_equal_str "0" "$?"
}

test_assert_in_str_raw(){
    # The 1st arg $expt is escaped again
    #     before being sent to the grep command
    # The 2nd arg is raw and not escaped again
    rslt=$(assert_in_str_raw "a" "ab")
    assert_equal_num 0 $?
    assert_equal_str "Pass" "$rslt"

    assert_in_str_raw '\\\\' '\\\\'
    assert_in_str_raw '\\n' '\\n'
}

test_in_str_asis_expt_raw_actl(){
    #  '' and "" work the same on \
    #      in this function

    # shouldn't find raw actl in pattern
    rslt=$(assert_in_str_asis_expt_raw_actl '\t' '\t') 
    assert_equal_num 64 $?
    printf '%s' "$rslt" | grep -Eq "'\\\\t' IS NOT in '\\\\t'"
    assert_equal_num 0 $?
    

    #assert_in_str_asis_expt_raw_actl '\t' "\t" 
}

test_in_str_transcode_actl(){
    rslt=$(assert_in_str_transcode_actl "\n" "\n")
    assert_equal_num 64 $?

    rslt=$(assert_in_str_transcode_actl '\t' '\t')
    assert_equal_num 64 $?
    printf '%s' "$rslt" | grep -Eq "'\\\\t' IS NOT in '\\\\t'"
    assert_equal_num 0 $?

    rslt=$(assert_in_str "" "a")
    assert_equal_num 1 $?
    printf "$rslt" | grep -Eq "Expt: is empty"
    assert_equal_num 0 $?
# 
#     rslt=$(assert_in_str "a" "")
#     assert_equal_num 64 $?
#     printf "$rslt" | grep -Eq "$1 IS NOT in $2"
#     assert_equal_num 0 $?
# 
#     rslt=$(assert_in_str "a" "a")
#     assert_equal_num 0 $?
#     printf "$rslt" | grep -Eq "Pass"
#     assert_equal_num 0 $?
# 
#     rslt=$(assert_in_str "a" "ba")
#     assert_equal_num 0 $?
#     printf "$rslt" | grep -Eq "Pass"
#     assert_equal_num 0 $?
}

test_assert_in_str(){
    # retval is 1 when grep "" in ""
    # after transcoded in grep, "\n" is similary to ""
    #     so the testcase will always pass
    #assert_in_str "\n" "\n"
    rslt=$(assert_in_str "\n" "\n")
    assert_equal_num 1 $?
    printf '%s' "$rslt" | grep -Pq 'Expt: Empty or newline expt after interpretion'
    assert_equal_num 0 $?
    
    rslt=$(assert_in_str "\\n" "\\n")
    assert_equal_num 1 $?
    printf '%s' "$rslt" | grep -Pq 'Expt: Empty or newline expt after interpretion'
    assert_equal_num 0 $?

    rslt=$(assert_in_str '\n' "\n")
    assert_equal_num 1 $?
    printf '%s' "$rslt" | grep -Pq 'Expt: Empty or newline expt after interpretion'
    assert_equal_num 0 $?

    # in grep, str is escaped twice, weirdly
    # in echo, "\\" is escaped, "\n" isn't. Also weird.
    # actl is [NEWLINE]
    rslt=$(assert_in_str "\\\\n" "\\n")
    assert_equal_num 64 $?
    printf "$rslt" | grep -Eq "IS NOT in"
    assert_equal_num 0 $?

    # actl is [NEWLINE]
    rslt=$(assert_in_str '\\n' "\n")
    assert_equal_num 64 $?
    printf "$rslt" | grep -Eq "IS NOT in"
    assert_equal_num 0 $?

    # 4 \\\\ to beinterpreted as 1 \
    # really awkward
    rslt=$(assert_in_str "\\\\n" "\n")
    assert_equal_num 64 $?
    printf "$rslt" | grep -Eq "IS NOT in"
    assert_equal_num 0 $?

    rslt=$(assert_in_str "" "a")
    printf "$rslt" | grep -Eq "Expt: is empty"
    assert_equal_num 0 $?
    
    #assert_in_str "a" ""
    rslt=$(assert_in_str "a" "")
    assert_equal_num 64 $?
    #echo "$rslt"
    printf "$rslt" | grep -Eq "'a' IS NOT in"
    printf "$rslt" | grep -Eq '"" or NEWLINE'
    assert_equal_num 0 $?

    rslt=$(assert_in_str "a" "a")
    printf "$rslt" | grep -Eq "Pass"
    assert_equal_num 0 $?

    rslt=$(assert_in_str "a" "ba")
    printf "$rslt" | grep -Eq "Pass"
    assert_equal_num 0 $?

    rslt=$(assert_in_str "hello" "hello\nworld")
    printf "$rslt" | grep -Eq "Pass"
    assert_equal_num 0 $?
}

test_assert_file_exists(){
    f1="$dpath_test"/f1
    [ ! -e "$f1" ] && touch "$f1"
    assert_file_exists "$f1"
}

test_assert_file_not_exists(){
    f1="$dpath_test"/f1
    [ -e "$f1" ] && rm "$f1"
    assert_file_not_exists "$f1"
}

test_assert_ltarget_exists(){
    f2="$dpath_test"/d_t1/f_f2
    l2="$dpath_test"/d_l1/f_f2
    touch $f2 
    ln -s "$f2" "$l2"
    assert_ltarget_exists "$l2"

    f3="$dpath_test"/d_t1/f_f3
    l3="$dpath_test"/d_l1/f_f3
    ln -s "$f3" "$l3"
    rslt=$(assert_ltarget_exists "$l3")
    assert_equal_num 64 $?
    assert_in_str "Fail:" "$rslt"
}

test_assert_ltarget_not_exists(){
    f4="$dpath_test"/d_t1/f_f4
    l4="$dpath_test"/d_l1/f_f4
    touch $f4
    ln -s "$f4" "$l4"
    rslt=$(assert_ltarget_not_exists "$l4")
    assert_equal_num 64 $?
    assert_in_str "Fail: Target File:" "$rslt"

    f5="$dpath_test"/d_t1/f_f5
    l5="$dpath_test"/d_l1/f_f5
    ln -s "$f5" "$l5"
    rslt=$(assert_ltarget_not_exists "$l5")
    assert_equal_num 0 $?
}

set -- -o
opt="$1"

#run_tests test_assert_ltarget_exists

tests1="test_hello test_init_dir_unexist test_init_dir_exist_no_op test_init_dir_exist_op"
tests2="test_assert_equal_str_raw test_assert_equal_str test_assert_equal_num test_assert_in_str_raw test_in_str_transcode_actl test_assert_in_str"
test3="test_assert_file_exists test_assert_file_not_exists test_assert_ltarget_exists test_assert_ltarget_not_exists"
tests="$tests1 $tests2 $tests3"
#run_tests "test_assert_in_str_raw"
#run_tests "$tests2"
run_tests $tests
