#!/usr/bin/env bash
export KUBECI_PATH=$(pwd)/kubeci

#############################################################################################
##                    BUILD SCRIPT
#############################################################################################

. ${KUBECI_PATH}/shell-utils/screen-utils.sh
. ${KUBECI_PATH}/shell-utils/version-utils.sh
. test/test.sh

VersionUtils.incrementVersion

tar -cf kubeci.tar kubeci

