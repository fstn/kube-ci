#!/bin/sh

. $KUBECI_PATH/shell-utils/screen-utils.sh
. $KUBECI_PATH/shell-utils/file-utils.sh
. $KUBECI_PATH/shell-utils/config-utils.sh


#############################################################################################
##                    EXTRACT BUILD AND DEPLOY IF CHANGES IN FOLDER
#############################################################################################
GitUtils.extractBuildAndDeployIfChangesInFolder(){
    buildAndDeployIfChangesInFolder=$(ConfigUtils.getValueFromConfig $1 "buildAndDeployIfChangesInFolder");
    if [ -z  $buildAndDeployIfChangesInFolder  ]
    then
        ScreenUtils.echoError "Unable to get buildAndDeployIfChangesInFolder for file $1 \n content:\n $(cat $1)"
        continue;
    fi
    echo $buildAndDeployIfChangesInFolder
}

#############################################################################################
##                          GET changes
#############################################################################################
GitUtils.getChanges()
{
    currentFolder="$1"
    if [ -z ${currentFolder} ]
    then
        ScreenUtils.echoError "currentFolder parameter can't be null"
    fi
    gitDiff=$(git diff HEAD~ --name-only ${currentFolder})
    echo ${gitDiff}
}

#############################################################################################
##                          CHANGE DETECTED
#############################################################################################
GitUtils.changeDetected()
{

    currentFolder="$1"
    if [ -z ${currentFolder} ]
    then
        ScreenUtils.echoError "currentFolder parameter can't be null"
    fi
    condition=$(echo ${global_projectsToBuild} | grep ${currentFolder}  | wc -l)
    if [ ${condition} -eq 1 ]; then
       echo 1
    else
        echo 0
    fi
    set +x
}

#############################################################################################
##                          DO IF CHANGE DETECTED
#############################################################################################
GitUtils.doIfChangesDetected()
{
    f="$1"
    action="$2"

    if [ -z ${f} ]
    then
        ScreenUtils.echoError "f parameter can't be null"
    fi
    if [ -z ${action} ]
    then
        ScreenUtils.echoError "action parameter can't be null"
    fi

    if [ -d ${f} ]
    then
        currentFolder=${f}
    else
        currentFolder=$(dirname ${f})
    fi

    changeDetected=$(GitUtils.changeDetected ${currentFolder})
    if [ "$changeDetected" = 1 ]
    then
        ScreenUtils.echoSuccess "[IN PROGRESS] $f"
        ${action}
    else
        ScreenUtils.echoWarning "[IGNORING] $currentFolder already up to date "
    fi
}


#############################################################################################
##                          GET DEPLOYMENT FILE
#############################################################################################
GitUtils.getDeploymentFile()
{
    folder="$1"
    if [ -z $folder ]
    then
        ScreenUtils.echoError "folder parameter can't be null"
    fi
    deploymentFile=$(ConfigUtils.getValueFromConfig $folder'/.gitlab-ci.config.yml' 'deploymentFile')
    if [ -z "$deploymentFile" ]
    then
        deploymentFile="0-deployment.k.yml"
    fi
    deploymentFile="$folder/$deploymentFile"
    echo $deploymentFile
}
