#!/bin/sh

. $KUBECI_PATH/shell-utils/screen-utils.sh

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
    echo "$result"
}
#############################################################################################
##                                  GET VALUE FROM CONFIG
#############################################################################################
ConfigUtils.getValueFromConfig()
{
    file="$1"
    key="$2"
    somethingToDo=$(FileUtils.verifyFileNoError $file "Nothing to do, to unable the action please add file:")
    if [ "$somethingToDo" = 1 ]
    then
        buildAndDeployIfChangesInFolder=$(cat "$file" | shyaml get-value $key 2>/dev/null)
    fi

    echo $buildAndDeployIfChangesInFolder
}