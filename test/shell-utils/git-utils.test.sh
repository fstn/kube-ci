#!/usr/bin/env bats

. ${KUBECI_PATH}/shell-utils/git-utils.sh

@test "GitUtils.changeDetected should detect changes" {
    PROJECT_ID="PROJECT_ID"
    BUILD_INCREMENT=1
    global_projectsToBuild="currentFolder2 currentFolder1 currentFolder"
    result=$(GitUtils.changeDetected "currentFolder")
    echo ${result}
    [ ${result} -eq 1 ]
}

@test "GitUtils.changeDetected should not detect changes" {
    PROJECT_ID="PROJECT_ID"
    BUILD_INCREMENT=1
    global_projectsToBuild="currentFolder2 currentFolder1 currentFolder"
    result=$(GitUtils.changeDetected "currentFolder3")
    echo ${result}
    [ ${result} -eq 0 ]
}

