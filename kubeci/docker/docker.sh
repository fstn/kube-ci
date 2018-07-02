#!/bin/sh

set -e
. $KUBECI_PATH/shell-utils/screen-utils.sh
. $KUBECI_PATH/shell-utils/kubernetes-utils.sh
. $KUBECI_PATH/shell-utils/docker-utils.sh
. $KUBECI_PATH/shell-utils/git-utils.sh

#############################################################################################
##                                  INIT FROM FILES
#############################################################################################
initFiles()
{
    echo "[START] Init files inside -> $1"
    for f in `find $1 -regex '.*/Dockerfile'| sort -n `; do
        export folder=$(dirname -- $f)
        export dockerWorkingFolder=$(python -c "import os.path; print os.path.relpath(\"$folder\",\"$SOURCE_FOLDER\")")
        ScreenUtils.echoBanner ${dockerWorkingFolder}
        export deploymentFile=$(GitUtils.getDeploymentFile ${folder})
        if [ -f ${deploymentFile} ]
        then
         action(){
            echo "[UPDATE] Data from file -> $deploymentFile"
            imageName=$(KubernetesUtils.extractImageName ${deploymentFile})
            deploymentName=$(KubernetesUtils.extractDeploymentName ${deploymentFile})
            podName=$(KubernetesUtils.extractPodName ${deploymentFile})
            DockerUtils.buildDocker ${imageName} ${BUILD_INCREMENT} ${dockerWorkingFolder}
            DockerUtils.pushDocker ${imageName} ${BUILD_INCREMENT}
            DockerUtils.deployDocker ${imageName} ${BUILD_INCREMENT} ${deploymentName} ${podName}
        }
        GitUtils.doIfChangesDetected $f action

        else
            ScreenUtils.echoError "Unable to find file $deploymentFile"
        fi
    done
    echo "[COMPLETED] Init files -> $1"
}

initFiles $(pwd)

