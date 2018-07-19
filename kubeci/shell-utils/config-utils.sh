#!/usr/bin/env bash

#############################################################################################
##                         UTILS FOR CONFIGURATION
#############################################################################################

. ${KUBECI_PATH}/shell-utils/screen-utils.sh
. ${KUBECI_PATH}/shell-utils/file-utils.sh

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
    result="$(echo "$result" | sed "s/[{][{]\.Values\.NAMESPACE[}][}]/$NAMESPACE/g")"
    echo "$result"
}
#############################################################################################
##                                  GET VALUE FROM CONFIG
#############################################################################################
ConfigUtils.getValueFromConfig()
{
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
    somethingToDo=$(FileUtils.verifyFileNoError ${file} "Nothing to do, to unable the action please add file:")
    if [ "$somethingToDo" = 1 ]
    then
        buildAndDeployIfChangesInFolder=$(cat "$file" | shyaml get-value ${key} 2>/dev/null)
    fi

    echo ${buildAndDeployIfChangesInFolder}
}
