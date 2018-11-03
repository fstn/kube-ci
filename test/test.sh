#!/usr/bin/env bash

#############################################################################################
##                    UNIT TESTING
#############################################################################################

KUBECI_PATH=$(pwd)/kubeci
bats ${KUBECI_PATH}/../test/shell-utils/function-utils.test.sh
bats ${KUBECI_PATH}/../test/shell-utils/config-utils.test.sh
bats ${KUBECI_PATH}/../test/shell-utils/git-utils.test.sh
bats ${KUBECI_PATH}/../test/shell-utils/kubernetes-utils.test.sh
bats ${KUBECI_PATH}/../test/shell-utils/version-utils.test.sh