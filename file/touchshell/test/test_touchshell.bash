#!/bin/bash

# Test the usage of vibash
# Operation on some files would fail on purpose
#     to show failure cases

# use ./test_vibash -o 
#     to override the check on the test dir/files


fpath=$(realpath "$0")
swd=${fpath%/*}

source "$swd"/testf.bashlib
source "$swd/../touchshell.bashlib"
source "$swd/../path.bashlib"

init_test_extra(){
    rm "$dpath_test/*" > /dev/null 2>&1
}

test_get_path_parts(){
    get_path_parts "a/b/c.bash"
    assert_equal_str "c.bash" "$fname"
    assert_equal_str "bash" "$fname_sfx"

    get_path_parts "a/b/bash"
    assert_equal_str "bash" "$fname"
    assert_equal_str "" "$fname_sfx"

    get_path_parts "tbash"
    assert_equal_str "tbash" "$fname"
    assert_equal_str "" "$fname_sfx"
}

test_get_fpath_new(){
    get_fpath_new "bash" "bash" "a/b/c.bash"
    assert_equal_str "a/b/c.bash" "$fpath_new"
    get_fpath_new "sh" "bash" "a/b/c.sh"
    assert_equal_str "a/b/c.sh.bash" "$fpath_new"
    get_fpath_new "" "bash" "a/b/c"
    assert_equal_str "a/b/c.bash" "$fpath_new"
    get_fpath_new "" "bash" "zbash"
    assert_equal_str "zbash.bash" "$fpath_new"
}

test_wrap_touch(){
    wrap_touch_by_stype_sfx(){
        stype="$1"
        sfx="$2"

        init_test_extra

        wrap_touch "$dpath_test/a.$sfx" "$stype" "$sfx"
        actual=$(head -1 $dpath_test/a.$sfx)
        assert_equal_str "#!/usr/bin/env $stype" "$actual"
    
    #    wrap_touch "$dpath_test/a.bash" "bash" >/dev/null 1>&2
        wrap_touch "$dpath_test/a.$sfx" "$stype" "$sfx"
        assert_equal_num 1 $?
    
        cd "$dpath_test"
        wrap_touch "bash3" "$stype" "$sfx"
        actual=$(head -1 ./bash3.$sfx)
        #assert_equal_str "#!/bin/$stype" "$actual"
        assert_equal_str "#!/usr/bin/env $stype" "$actual"
        cd -
    }

    shell_type_list="bash sh"
    for type in $shell_type_list
        do
        sfx_list=$(echo $type "$type"lib)
        for sfx in $sfx_list
            do
            wrap_touch_by_stype_sfx $type $sfx
        done
    done
}

opt="-o"
#run_tests "test_get_path_parts" 
#run_tests "test_wrap_touch" 
run_tests "test_get_path_parts" "test_get_fpath_new" "test_wrap_touch"
