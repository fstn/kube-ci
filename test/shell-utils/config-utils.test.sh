#!/usr/bin/env bats

. ${KUBECI_PATH}/shell-utils/config-utils.sh
. ${KUBECI_PATH}/shell-utils/function-utils.sh

@test "ConfigUtils.replaceVariables should replace variables" {
    PROJECT_ID="PROJECT_ID"
    LOG_LEVEL="info"
    DEBUG=true
    BUILD_INCREMENT=1
    result=$(ConfigUtils.replaceVariables "{{.Values.PROJECT_ID}}{{.Values.VERSION}}")
    echo ${result}
    [ ${result} = ${PROJECT_ID}${BUILD_INCREMENT} ]
}

@test "ConfigUtils.replaceVariables should replace variables with empty string" {
    result=$(ConfigUtils.replaceVariables "{{.Values.PROJECT_ID}}{{.Values.VERSION}}")
    echo ${result}
    [ "${result}" = "" ]
}

@test "ConfigUtils.getValueFromConfig should return value" {
    PROJECT_ID="PROJECT_ID"
    LOG_LEVEL="info"
    DEBUG=true
    BUILD_INCREMENT=1
    echo "test: myValue" >> test.yml
    result=$(ConfigUtils.getValueFromConfig "test.yml" "test")
    rm -f test.yml
    echo ${result}
    [ "${result}" = "myValue" ]
}

@test "ConfigUtils.getValueFromConfig should not return value" {
    PROJECT_ID="PROJECT_ID"
    LOG_LEVEL="info"
    DEBUG=true
    BUILD_INCREMENT=1
    echo "test: myValue" >> test.yml
    result=$(ConfigUtils.getValueFromConfig "test.yml" "unexistant")
    rm -f test.yml
    echo ${result}
    [ "${result}" = "" ]
}

@test "ConfigUtils.exportAllVariablesFrom should return error values" {
    PROJECT_ID="PROJECT_ID"
    LOG_LEVEL="info"
    DEBUG=true
    BUILD_INCREMENT=1
    echo "test:" >> test.yml
    echo " test1:1 " >> test.yml
    echo " test2: 2 " >> test.yml
    $(ConfigUtils.exportAllVariablesFrom "test.yml" "test")
    error=$(FunctionUtils.getError "ConfigUtils.exportAllVariablesFrom")
    rm -f test.yml
    [ ! -z "${error}" ]
}

@test "ConfigUtils.exportAllVariablesFrom should export  values" {
    PROJECT_ID="PROJECT_ID"
    LOG_LEVEL="info"
    DEBUG=true
    BUILD_INCREMENT=1
    echo "test:" >> test.yml
    echo " test1: 1 " >> test.yml
    echo " test2: 2 " >> test.yml
    $(ConfigUtils.exportAllVariablesFrom "test.yml" "test")
    . $(FunctionUtils.getResultFile "ConfigUtils.exportAllVariablesFrom")
    rm -f test.yml
    [ "${test1}" = 1 ]
}