#!/usr/bin/env bash

#############################################################################################
##                         UTILS FOR CONFIGURATION
#############################################################################################

. ${KUBECI_PATH}/shell-utils/screen-utils.sh
. ${KUBECI_PATH}/shell-utils/file-utils.sh
. ${KUBECI_PATH}/shell-utils/function-utils.sh


#############################################################################################
##                                REPLACE VARIABLES INTO FILES
#############################################################################################
ConfigUtils.replaceVariables()
{
    fileContent="$1"
    if [ -z "$fileContent" ]
    then
        ScreenUtils.echoError "File content can't be empty"
    fi
    result="$(echo "$fileContent" | sed "s/[{][{]\.Values\.PROJECT_ID[}][}]/$PROJECT_ID/g")"
    result="$(echo "$result" | sed "s/[{][{]\.Values\.VERSION[}][}]/$BUILD_INCREMENT/g")"
    result="$(echo "$result" | sed "s/[{][{]\.Values\.DNS[}][}]/$DNS/g")"
    result="$(echo "$result" | sed "s/[{][{]\.Values\.LOG_LEVEL[}][}]/$DNS/g")"
    result="$(echo "$result" | sed "s/[{][{]\.Values\.DEBUG[}][}]/$DNS/g")"
    result="$(echo "$result" | sed "s/[{][{]\.Values\.NAMESPACE[}][}]/$NAMESPACE/g")"
    echo "$result"
}
#############################################################################################
##                                  GET VALUE FROM CONFIG
#############################################################################################
ConfigUtils.getValueFromConfig()
{
    fun="ConfigUtils.getValueFromConfig"
    rm .getValueFromConfig.error 2>/dev/null
    file="$1"
    if [ -z "file" ]
    then
        ScreenUtils.echoError "File can't be empty"
    fi
    key="$2"
    if [ -z "$key" ]
    then
        ScreenUtils.echoError "key can't be empty"
    fi
    FunctionUtils.begin $fun
    somethingToDo=$(FileUtils.verifyFileNoError ${file} "Nothing to do, to unable the action please add file:")
    if [ "$somethingToDo" = 1 ]
    then
        buildAndDeployIfChangesInFolder=$(cat "$file" | shyaml get-value ${key} 2>  $(FunctionUtils.getErrorFile $fun))
    fi

    echo "${buildAndDeployIfChangesInFolder}"
}

#############################################################################################
##                           EXPORT ALL VARIABLES FROM
#############################################################################################
ConfigUtils.exportAllVariablesFrom()
{
    fun="ConfigUtils.exportAllVariablesFrom"
    file="$1"
    if [ -z "file" ]
    then
        ScreenUtils.echoError "File can't be empty"
    fi
    key="$2"
    if [ -z "$key" ]
    then
        ScreenUtils.echoError "key can't be empty"
    fi
    FunctionUtils.begin $fun
    rm .exportAllVariablesFrom.result 2>/dev/null
    rm .exportAllVariablesFrom.error 2>/dev/null
    toExport=""
    configs=$(ConfigUtils.getValueFromConfig "${file}" "${key}")
    error=$(FunctionUtils.getError "ConfigUtils.getValueFromConfig")
    if ! [ -z "${error}" ]
    then
        FunctionUtils.addError $fun "Unable to parse ${file}, file must respect yml, ${error}"
    fi
    $(echo "${configs}" |
        while IFS=": " read -r name value; do
            if [ -z "$name" ]
            then
                FunctionUtils.addError "name can't be empty in ${file} file must respect yml"
            fi

            if [ -z "$value" ]
            then
                FunctionUtils.addError "value can't be empty for key ${name} in ${file}"
            fi
            FunctionUtils.addResult $fun "${name}=${value}"
      done)
}

