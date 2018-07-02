#!/bin/sh

. $KUBECI_PATH/shell-utils/screen-utils.sh
. $KUBECI_PATH/shell-utils/config-utils.sh
. $KUBECI_PATH/shell-utils/file-utils.sh

#############################################################################################
##                                GET FILE CONTENT FROM TEMPLATE
#############################################################################################
getFileContentFromTemplate(){
    deploymentFile="$1"
    if [ -z $deploymentFile ]
    then
        ScreenUtils.echoError "deploymentFile parameter can't be null"
    fi

    FileUtils.verifyFile $deploymentFile
    fileContent=$(cat $deploymentFile)
    echo "$(ConfigUtils.replaceVariables "$fileContent")"
}

#############################################################################################
##                                   EXTRACT IMAGE NAME
#############################################################################################
KubernetesUtils.extractImageName()
{
    deploymentFile=$1
    if [ -z $deploymentFile ]
    then
        ScreenUtils.echoError "deploymentFile parameter can't be null"
    fi

    FileUtils.verifyFile $deploymentFile
    imageName=$(getFileContentFromTemplate "$deploymentFile" | shyaml get-value spec.template.spec.containers.0.image |  cut -d':' -f 1)
    if [ -z  $imageName  ]
    then
        ScreenUtils.echoError "Unable to get image name for deployment file $deploymentFile"
        continue;
    fi

    echo $imageName
}

#############################################################################################
##                                   EXTRACT DEPLOYMENT NAME
#############################################################################################
KubernetesUtils.extractDeploymentName()
{
    deploymentFile=$1
    if [ -z $deploymentFile ]
    then
        ScreenUtils.echoError "deploymentFile parameter can't be null"
    fi

    FileUtils.verifyFile $deploymentFile
    deploymentName=$(getFileContentFromTemplate "$deploymentFile" | shyaml get-value metadata.name )
    if [ -z  deploymentName  ]
    then
        ScreenUtils.echoError "Unable to get deployment name for deployment file $deploymentFile"
        continue;
    fi
    echo $deploymentName
}

#############################################################################################
##                                   EXTRACT POD NAME
#############################################################################################
KubernetesUtils.extractPodName()
{
    deploymentFile=$1
    if [ -z $deploymentFile ]
    then
        ScreenUtils.echoError "deploymentFile parameter can't be null"
    fi

    FileUtils.verifyFile $deploymentFile
    podName=$(getFileContentFromTemplate "$deploymentFile" | shyaml get-value spec.template.metadata.labels.app  )
    if [ -z  podName  ]
    then
        ScreenUtils.echoError "Unable to get pod name for deployment file $deploymentFile"
        continue;
    fi
    echo $podName
}
