#!/usr/bin/env bash

#############################################################################################
##                         UTILS FOR VERSION MANAGEMENT
#############################################################################################

. ${KUBECI_PATH}/shell-utils/screen-utils.sh
configFile=${KUBECI_PATH}/version.ini


#############################################################################################
##                          Read version from version file
#############################################################################################
VersionUtils.readVersion(){
    IFS='=' read var value < ${configFile}
        if [ -z ${value} ]
        then
            ScreenUtils.echoError "Unable to read version from version.ini"
        fi
        export "$var"="$value"
    if [ -z ${version} ]
    then
        ScreenUtils.echoError "Unable to read version from version.ini"
    fi
    echo ${version}
}

#############################################################################################
##                    Increment version number
#############################################################################################
VersionUtils.incrementVersion(){
    version=$(VersionUtils.readVersion)
    if [ -z ${version} ]
    then
        ScreenUtils.echoError "Unable to read version from version.ini"
    fi
    version=$(expr ${version} + 1 )
    ScreenUtils.echoImportant "Updating to version ${version}"
    echo  $(sed 's/.*/version='${version}'/g' ${configFile}) >  ${configFile}
}