#!/bin/sh

set -e
. $KUBECI_PATH/shell-utils/helm-utils.sh
. $KUBECI_PATH/shell-utils/screen-utils.sh
. $KUBECI_PATH/shell-utils/git-utils.sh

#############################################################################################
##                                 APPLY HELM CONFIG
#############################################################################################
## More about Helm https://helm.sh/

applyHelmConfig()
{
set -x
    ScreenUtils.echoBanner "APPLY HELM CONFIG"
    echo "[START] Init files inside -> $1"
    for f in `find $1 -regex '.*/[0-9][^/]*.k.helm.yml'| sort -n `; do
        echo "[APPLY] file -> $f"
        export f=$f
        action(){
            HelmUtils.installOrUpdateHelmRelease $(HelmUtils.extractReleaseName $f) $(HelmUtils.extractChartName $f) $f $(HelmUtils.extractNamespace $f)
        }
        GitUtils.doIfChangesDetected $f action
    done
    echo "[COMPLETED] Init files -> $1"
    set  +x
}

applyHelmConfig `old=$(pwd);cd ../;pwd;cd $old`



