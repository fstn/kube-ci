#!/bin/sh

. $KUBECI_PATH/shell-utils/screen-utils.sh
. $KUBECI_PATH/shell-utils/config-utils.sh
#############################################################################################
##                                  VERIFY IF FILE IS OK
#############################################################################################
FileUtils.verifyFile()
{
 if [ ! -f  $1  ]
    then
       ScreenUtils.echoError "Unable to open file $1"
    fi
}
#############################################################################################
##                                  VERIFY IF FILE IS OK AND NOT THROW ERROR
#############################################################################################
FileUtils.verifyFileNoError()
{
 msg=$2
 if [ ! -f  $1  ]
    then
       echo "$msg: $1"
    else
        echo 1
    fi
}