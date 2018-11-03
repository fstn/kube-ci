#!/usr/bin/env bats

. ${KUBECI_PATH}/shell-utils/function-utils.sh

@test "FunctionUtils.begin should not throw error" {
    PROJECT_ID="PROJECT_ID"
    LOG_LEVEL="info"
    DEBUG=true
    BUILD_INCREMENT=1
    global_projectsToBuild="currentFolder2 currentFolder1 currentFolder"
    $(FunctionUtils.begin "myFunction")
}

@test "FunctionUtils.addResult should add result to the result file" {
    PROJECT_ID="PROJECT_ID"
    LOG_LEVEL="info"
    DEBUG=true
    BUILD_INCREMENT=1
    global_projectsToBuild="currentFolder2 currentFolder1 currentFolder"
    $(FunctionUtils.addResult "myFunction" "result")
    [ $(FunctionUtils.getResult "myFunction") = "result" ]
}

@test "FunctionUtils.addError should add result to the result file" {
    PROJECT_ID="PROJECT_ID"
    LOG_LEVEL="info"
    DEBUG=true
    BUILD_INCREMENT=1
    global_projectsToBuild="currentFolder2 currentFolder1 currentFolder"
    $(FunctionUtils.addError "myFunction" "error")
    error=$(FunctionUtils.getError "myFunction")
    [ "${error}" = "error" ]
}

@test "FunctionUtils.end should not throw error" {
    PROJECT_ID="PROJECT_ID"
    LOG_LEVEL="info"
    DEBUG=true
    BUILD_INCREMENT=1
    global_projectsToBuild="currentFolder2 currentFolder1 currentFolder"
    $(FunctionUtils.end "myFunction")
}
