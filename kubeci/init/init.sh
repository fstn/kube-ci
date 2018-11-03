#!/usr/bin/env bash

#############################################################################################
##                         INIT APPLIER
## Will mark all project to rebuild based on gitDiff result
## It can be skip if the all variable is set
#############################################################################################

. ${KUBECI_PATH}/shell-utils/screen-utils.sh
. ${KUBECI_PATH}/shell-utils/git-utils.sh
. ${KUBECI_PATH}/shell-utils/config-utils.sh
. ${KUBECI_PATH}/shell-utils/function-utils.sh

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

    echo "[INIT] all environment variables before exporting all .deployments.gitlab-ci.yml:"
    env
    ConfigUtils.exportAllVariablesFrom ".deployments.gitlab-ci.yml" "${CI_COMMIT_REF_NAME}"
    echo "[INIT] environment variables found inside .deployments.gitlab-ci.yml:"
    result=$(FunctionUtils.getResult "ConfigUtils.exportAllVariablesFrom")
    while read line
    do
        export $(echo "${line}")
    done <<< "$(echo -e "$result")"

    ScreenUtils.echoImportant "[INIT] all environment variables after exporting all .deployments.gitlab-ci.yml:"
    env
    export DNS=$(ConfigUtils.getValueFromConfig ".deployments.gitlab-ci.yml" "${CI_COMMIT_REF_NAME}.dns")
    export DEBUG=$(ConfigUtils.getValueFromConfig ".deployments.gitlab-ci.yml" "${CI_COMMIT_REF_NAME}.debug")
    export LOG_LEVEL=$(ConfigUtils.getValueFromConfig ".deployments.gitlab-ci.yml" "${CI_COMMIT_REF_NAME}.logLevel")
    export CONFIG=$(ConfigUtils.getValueFromConfig ".deployments.gitlab-ci.yml" "${CI_COMMIT_REF_NAME}.CONFIG")
    echo "Reading DNS: ${DNS}"


    if [ -z  ${NAMESPACE} ]
    then
        export NAMESPACE=$(ConfigUtils.getValueFromConfig ".deployments.gitlab-ci.yml" "${CI_COMMIT_REF_NAME}.namespace")
        namespaceExists=$(kubectl get namespace | grep -e "^${NAMESPACE} "| wc -l)
        if [ ${namespaceExists} -eq 0 ]
        then
            kubectl create namespace ${NAMESPACE}
        fi
        echo "Reading NAMESPACE: ${NAMESPACE}"
     else
        echo "Existing NAMESPACE: ${NAMESPACE}"
    fi

    for f in `find $1 -regex ".*/.gitlab-ci.config.yml"| sort -n `; do
        echo "[APPLY] file -> $f"
        export f=${f}
#        cd $(dirname ${f})
        # Run all build script define in yaml file
        buildAndDeployIfChangesInFolder=$(ConfigUtils.getValueFromConfig ${f} "buildAndDeployIfChangesInFolder")
        change=$(echo ${gitDiff} | grep "$buildAndDeployIfChangesInFolder" | wc -l)
        if [ ${change} -ge 1 ] || [ ${all} -eq 1 ]
        then
             listOfDependencies=$(ConfigUtils.getValueFromConfig ${f} "listOfDependencies")
             if [ -z ${listOfDependencies} ]
             then
                ScreenUtils.echoWarning  "[INIT] No dependency for $(dirname ${f})"
             fi
             for dependency in ${listOfDependencies}
             do
                dependencyFolder="$(pwd)/${dependency}"
                if [ ! -d ${dependencyFolder} ];
                then
                    ScreenUtils.echoError  "[INIT] Dependency ${dependencyFolder} is not a directory "
                fi
                if [[ ! " ${projectsToBuild[@]} " =~ " ${dependencyFolder} " ]];
                then
                    ScreenUtils.echoSuccess  "[INIT] Add dependency ${dependencyFolder} for $(dirname ${f}) to the build queue"
                    projectsToBuild+=(${dependencyFolder})
                else
                    ScreenUtils.echoWarning  "[INIT] Dependency ${dependencyFolder} already added to the build queue "
                fi
             done

             if [[ ! " ${projectsToBuild[@]} " =~ " $(dirname ${f}) " ]];
             then
                ScreenUtils.echoSuccess  "[INIT] Add ${f} to the build queue"
                projectsToBuild+=($(dirname ${f}))
             else
                ScreenUtils.echoWarning  "[INIT] ${f} already added to the build queue "
             fi
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