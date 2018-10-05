#!/usr/bin/env bash

#############################################################################################
##                         UTILS FOR HELM
#############################################################################################

. ${KUBECI_PATH}/shell-utils/screen-utils.sh
. ${KUBECI_PATH}/shell-utils/config-utils.sh
. ${KUBECI_PATH}/shell-utils/kubernetes-utils.sh

#############################################################################################
##                                   UPDATE HELM RELEASE
#############################################################################################
HelmUtils.updateHelmRelease()
{
    releaseName=$1
    chartPath=$2
    namespace=$3
    helm --tiller-namespace ${namespace} upgrade ${releaseName} ${chartPath} --set=VERSION=${BUILD_INCREMENT},PROJECT_ID=${PROJECT_ID},DNS=${DNS},LOG_LEVEL=${LOG_LEVEL},DEBUG=${DEBUG},NAMESPACE=${NAMESPACE} --reuse-values
    if [ $? -eq 0 ]; then
        echo "$releaseName updated"
    else
        ScreenUtils.echoError "Unable to update helm release $releaseName"
    fi
}

#############################################################################################
##                                   INSTALL HELM RELEASE
#############################################################################################
HelmUtils.installHelmRelease()
{
    releaseName=$1
    chartPath=$2
    values=$3
    namespace=$4
    helm install ${chartPath} --tiller-namespace ${namespace} --set fullnameOverride=${releaseName},PROJECT_ID=${PROJECT_ID},VERSION='latest',DNS=${DNS},LOG_LEVEL=${LOG_LEVEL},DEBUG=${DEBUG},NAMESPACE=${NAMESPACE} --name ${releaseName}
    if [ $? -eq 0 ]; then
        echo "$releaseName installed"
    else
        ScreenUtils.echoError "Unable to install helm release $releaseName"
    fi
}

#############################################################################################
##                                   INSTALL OR UDPATE HELM RELEASE
#############################################################################################
HelmUtils.installOrUpdateHelmRelease()
{
    releaseName=$1
    chartPath=$2
    values=$3
    namespace=$4
    if [ -z ${namespace} ]
    then
        namespace="gitlab-managed-apps"
    fi
    helmResult=$(helm --tiller-namespace ${namespace} get ${releaseName} 2>/dev/null |wc -l)
    if [ ${helmResult} -gt 0 ]; then
        HelmUtils.updateHelmRelease ${releaseName} ${chartPath} ${namespace} ${BUILD_INCREMENT}
    else
        HelmUtils.installHelmRelease ${releaseName} ${chartPath} ${values} ${namespace}
    fi
}

#############################################################################################
##                                   EXTRACT RELEASE NAME
#############################################################################################
HelmUtils.extractReleaseName()
{
    deploymentFile=$1
    if [ -z ${deploymentFile} ]
    then
        ScreenUtils.echoError "deploymentFile parameter can't be null"
    fi

    FileUtils.verifyFile ${deploymentFile}
    releaseName=$(cat "$deploymentFile" | shyaml get-value helm.releaseName |  cut -d':' -f 1)
    if [ -z  ${releaseName}  ]
    then
        ScreenUtils.echoError "Unable to get release name for deployment file $deploymentFile"
        continue;
    fi

    echo ${releaseName}
}

#############################################################################################
##                                   EXTRACT CHART NAME
#############################################################################################
HelmUtils.extractChartName()
{
    deploymentFile=$1
    if [ -z ${deploymentFile} ]
    then
        ScreenUtils.echoError "deploymentFile parameter can't be null"
    fi

    FileUtils.verifyFile ${deploymentFile}
    chartName=$(cat "$deploymentFile" | shyaml get-value helm.chart |  cut -d':' -f 1)
    if [ -z  ${chartName}  ]
    then
        ScreenUtils.echoError "Unable to get chart name for deployment file $deploymentFile"
        continue;
    fi

    echo ${chartName}
}

#############################################################################################
##                                   EXTRACT CHART NAME
#############################################################################################
HelmUtils.extractNamespace()
{
    deploymentFile=$1
    if [ -z ${deploymentFile} ]
    then
        ScreenUtils.echoError "deploymentFile parameter can't be null"
    fi

    FileUtils.verifyFile ${deploymentFile}
    namespace=$(cat "$deploymentFile" | shyaml get-value helm.namespace |  cut -d':' -f 1)
    if [ -z  ${namespace}  ]
    then
        ScreenUtils.echoError "Unable to get namespace for deployment file $namespace"
        continue;
    fi

    echo ${namespace}
}