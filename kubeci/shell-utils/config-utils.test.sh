#!/usr/bin/env bats

KUBECI_PATH=$(pwd)
. ${KUBECI_PATH}/shell-utils/config-utils.sh

@test "Replace variable should replace variables" {
    PROJECT_ID="PROJECT_ID"
    BUILD_INCREMENT=1
    result=$(ConfigUtils.replaceVariables "{{.Values.PROJECT_ID}}{{.Values.VERSION}}")
    echo $result
    [ ${result} = ${PROJECT_ID}${BUILD_INCREMENT} ]
}
