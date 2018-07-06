#!/usr/bin/env bats

. ${KUBECI_PATH}/shell-utils/kubernetes-utils.sh

deploymentFile="${KUBECI_PATH}/../test/test-deployment.yml"


#############################################################################################
##                                GET FILE CONTENT FROM TEMPLATE
#############################################################################################
@test "getFileContentFromTemplate should return file content and replace variables" {
    PROJECT_ID="PROJECT_ID"
    BUILD_INCREMENT=1
    result=$(getFileContentFromTemplate ${deploymentFile})
    echo "result: "${result}
    [ ! -z "${result}" ]
}

#############################################################################################
##                                   EXTRACT IMAGE NAME
#############################################################################################
@test "KubernetesUtils.extractImageName should return imageName and replace variables" {
    PROJECT_ID="PROJECT_ID"
    BUILD_INCREMENT=1
    result=$(KubernetesUtils.extractImageName ${deploymentFile})
    echo "result: "${result}
    [ ${result} = "gcr.io/PROJECT_ID/wecom-backend-server" ]
}

#############################################################################################
##                                   EXTRACT DEPLOYMENT NAME
#############################################################################################
@test "KubernetesUtils.extractDeploymentName should return deploymentName and replace variables" {
    PROJECT_ID="PROJECT_ID"
    BUILD_INCREMENT=1
    result=$(KubernetesUtils.extractDeploymentName ${deploymentFile})
    echo "result: "${result}
    [ ${result} = "wecom-backend-server-deployment" ]
}

#############################################################################################
##                                   EXTRACT POD NAME
#############################################################################################
@test "KubernetesUtils.extractPodName should return pod name and replace variables" {
    PROJECT_ID="PROJECT_ID"
    BUILD_INCREMENT=1
    result=$(KubernetesUtils.extractPodName ${deploymentFile})
    echo "result: "${result}
    [ ${result} = "wecom-backend-server" ]
}
