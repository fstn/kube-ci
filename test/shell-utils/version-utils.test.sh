#!/usr/bin/env bats

. ${KUBECI_PATH}/shell-utils/version-utils.sh

export configFile=version.ini

#############################################################################################
##                          Read version from version file
#############################################################################################
@test "VersionUtils.readVersion should return current version" {
    echo "version=11" >> ${configFile}
    result=$(VersionUtils.readVersion)
    rm -f version.ini
    echo ${result}
    [ "${result}" = "11" ]
}

#############################################################################################
##                    Increment version number
#############################################################################################
@test "VersionUtils.incrementVersion should increment current version" {
    echo "version=11" >> ${configFile}
    result=$(VersionUtils.incrementVersion)
    result=$(VersionUtils.readVersion)
    rm -f version.ini
    echo ${result}
    [ "${result}" = "12" ]
}