#!/bin/sh

set -e
. $KUBECI_PATH/shell-utils/kubernetes-utils.sh
. $KUBECI_PATH/shell-utils/screen-utils.sh
. $KUBECI_PATH/shell-utils/git-utils.sh

#############################################################################################
##                              TRY TO FILL LAST VERSION
#############################################################################################
tryToFillLastVersion(){
    f=$1
    deploymentFile=$(GitUtils.getDeploymentFile $(dirname $f))
    # If there is no deployment file, we don't need the LAST_VERSION variable
    if [ -f deploymentFile ]
    then
        imageName=$(KubernetesUtils.extractImageName $deploymentFile)
        export LAST_VERSION=$(gcloud container images list-tags gcr.io/$PROJECT_ID/$imageName --limit=1 | tail -n 1 | awk '{print $2}')
    fi
}

#############################################################################################
##                                 APPLY KUBERNETES CONFIG
#############################################################################################
applyKubernetesConfig()
{

    ScreenUtils.echoBanner "APPLY KUBERNETES CONFIG"
    echo "[START] Init files inside -> $1"
    for f in `find $1 -regex '.*/[0-9]\-[0-9]*[^/]*.k.yml'| sort -n `; do
        echo "[APPLY] file -> $f"
        export f=$f
        action(){
            tryToFillLastVersion $f
            getFileContentFromTemplate  $f | kubectl apply --namespace=default -f -
        }
        GitUtils.doIfChangesDetected $f action
    done
    for f in `find $1 -regex '.*/[0-9][^/]*.k.sh'| sort -n `; do
        echo "[RUN] file -> $f"
        export f=$f
        action(){
        sh $f
        }
        GitUtils.doIfChangesDetected $f action
    done
    echo "[COMPLETED] Init files -> $1"
}

applyKubernetesConfig `old=$(pwd);cd ../;pwd;cd $old`



