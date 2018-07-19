#!/usr/bin/env bash

#############################################################################################
##                         INIT APPLIER
## Will mark all project to rebuild based on gitDiff result
## It can be skip if the all variable is set
#############################################################################################

. ${KUBECI_PATH}/shell-utils/screen-utils.sh
. ${KUBECI_PATH}/shell-utils/git-utils.sh
. ${KUBECI_PATH}/shell-utils/config-utils.sh

#############################################################################################
##                                  BUILD
#############################################################################################
build()
{
    all=$2
    ScreenUtils.echoBanner "INITIALIZE"
    gitDiff=$(GitUtils.getChanges $1)
    ScreenUtils.echoImportant "[INIT] The Current changes are: "
    for diff in ${gitDiff}
    do
         ScreenUtils.echoImportant ${diff}
    done
    echo "[INIT] read config files inside -> $1"
    export gitDiff=$(GitUtils.getChanges $1)
    echo "[INIT] read deployment config files inside -> .deployments.gitlab-ci.yml for branch ${CI_COMMIT_REF_NAME}"

    export DNS=$(ConfigUtils.getValueFromConfig ".deployments.gitlab-ci.yml" "${CI_COMMIT_REF_NAME}.dns")
    echo "Reading DNS: ${DNS}"

    export NAMESPACE=$(ConfigUtils.getValueFromConfig ".deployments.gitlab-ci.yml" "${CI_COMMIT_REF_NAME}.namespace")
    namespaceExists=$(kubectl get namespace | grep -e "^staging "| wc -l)
    if [ ${namespaceExists} -eq 0 ]
    then
        kubectl create namespace ${NAMESPACE}
    fi
    echo "Reading NAMESPACE: ${NAMESPACE}"

    for f in `find $1 -regex ".*/.gitlab-ci.config.yml"| sort -n `; do
        echo "[APPLY] file -> $f"
        export f=${f}
#        cd $(dirname ${f})
        # Run all build script define in yaml file
        buildAndDeployIfChangesInFolder=$(ConfigUtils.getValueFromConfig ${f} "buildAndDeployIfChangesInFolder")
        change=$(echo ${gitDiff} | grep "$buildAndDeployIfChangesInFolder" | wc -l)
        if [ ${change} -ge 1 ] || [ ${all} -eq 1 ]
        then
             ScreenUtils.echoSuccess  "[INIT] Add $f to the build queue "
             projectsToBuild+=($(dirname ${f}))
        else
            ScreenUtils.echoWarning "[INIT] Ignoring $f already up to date "
        fi
    done

    ScreenUtils.echoImportant "[INIT] The Projects to build are: "
    for projectToBuild in ${projectsToBuild[@]}
    do
        ScreenUtils.echoImportant "add ${projectToBuild}"
        global_projectsToBuild+="${projectToBuild} "
    done
    echo "[INIT] build files -> $1"
}

build  $(pwd) $1