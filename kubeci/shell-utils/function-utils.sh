#!/usr/bin/env bash

#############################################################################################
##                         UTILS FOR FUNCTION
#############################################################################################

. ${KUBECI_PATH}/shell-utils/screen-utils.sh
. ${KUBECI_PATH}/shell-utils/file-utils.sh

#############################################################################################
##                                BEGIN OF THE FUNCTION
#############################################################################################
FunctionUtils.begin()
{
    functionName="$1"
    if [ -z "functionName" ]
    then
        ScreenUtils.echoError "Function name can't be empty"
    fi
    rm $(FunctionUtils.getResultFile "${functionName}") 2>/dev/null
    rm $(FunctionUtils.getErrorFile "${functionName}") 2>/dev/null
    return 0
}

#############################################################################################
##                                  END OF THE FUNCTION
#############################################################################################
FunctionUtils.end()
{
    functionName="$1"
    if [ -z "functionName" ]
    then
        ScreenUtils.echoError "Function name can't be empty"
    fi
    rm $(FunctionUtils.getResultFile "${functionName}") 2>/dev/null
    rm $(FunctionUtils.getErrorFile "${functionName}") 2>/dev/null
    return 0
}

#############################################################################################
##                                  RETURN FUNCTION RESULT FILE NAME
#############################################################################################
FunctionUtils.getResultFile()
{
    functionName="$1"
    if [ -z "functionName" ]
    then
        ScreenUtils.echoError "Function name can't be empty"
    fi
    echo ".${functionName}.result"
}

#############################################################################################
##                                  RETURN FUNCTION RESULT AS STRING
#############################################################################################
FunctionUtils.getResult()
{
    functionName="$1"
    if [ -z "functionName" ]
    then
        ScreenUtils.echoError "Function name can't be empty"
    fi
    echo $(cat $(FunctionUtils.getResultFile "${functionName}"))
}

#############################################################################################
##                                  RETURN FUNCTION ERROR AS STRING
#############################################################################################
FunctionUtils.getError()
{
    functionName="$1"
    if [ -z "functionName" ]
    then
        ScreenUtils.echoError "Function name can't be empty"
    fi
    echo $(cat $(FunctionUtils.getErrorFile "${functionName}"))
}

#############################################################################################
##                                   RETURN FUNCTION ERROR FILE NAME
#############################################################################################
FunctionUtils.getErrorFile()
{
    functionName="$1"
    if [ -z "functionName" ]
    then
        ScreenUtils.echoError "Function name can't be empty"
    fi
    echo ".${functionName}.error"
}

#############################################################################################
##                                 ADD RESULT TO THE OUTPUT
#############################################################################################
FunctionUtils.addResult()
{
    functionName="$1"
    if [ -z "functionName" ]
    then
        ScreenUtils.echoError "Function name can't be empty"
    fi
    functionResult="$2"
    if [ -z "functionResult" ]
    then
        ScreenUtils.echoError "Function result can't be empty"
    fi
    echo "${functionResult}" >> $(FunctionUtils.getResultFile "${functionName}")
}

#############################################################################################
##                                 ADD ERROR TO THE OUTPUT
#############################################################################################
FunctionUtils.addError()
{
    functionName="$1"
    if [ -z "functionName" ]
    then
        ScreenUtils.echoError "Function name can't be empty"
    fi
    functionError="$2"
    if [ -z "functionError" ]
    then
        ScreenUtils.echoError "Function error can't be empty"
    fi
    errorFile=$(FunctionUtils.getErrorFile "${functionName}")
    echo "${functionError}" >> "${errorFile}"
}