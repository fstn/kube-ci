#!/bin/sh

. ${KUBECI_PATH}/shell-utils/screen-utils.sh

#############################################################################################
##                                  BUILD DOCKER
#############################################################################################
DockerUtils.buildDocker()
{
    imageName=$1
    if [ -z ${imageName} ]
    then
        ScreenUtils.echoError "imageName parameter can't be null"
    fi

    buildCounter=$2
    if [ -z ${buildCounter} ]
    then
        ScreenUtils.echoError "buildCounter parameter can't be null"
    fi

    folder=$3
    if [ -z ${folder} ]
    then
        ScreenUtils.echoError "folder parameter can't be null"
    fi

    ScreenUtils.separateLine
    echo "[BUILD] Docker -> $imageName"
    echo "[BUILD] Docker folder -> $folder"
    echo "[BUILD] Docker home-> $SOURCE_FOLDER"
    echo "[BUILD] Docker version-> $buildCounter"

    docker build -t ${imageName}:${buildCounter} -f ${SOURCE_FOLDER}/${folder}/Dockerfile --build-arg folder=${folder} ${SOURCE_FOLDER}
    docker build tag ${imageName}:${buildCounter} ${imageName}:latest
}
#############################################################################################
##                                  PUSH DOCKER
#############################################################################################
DockerUtils.pushDocker()
{
    imageName=$1
    if [ -z ${imageName} ]
    then
        ScreenUtils.echoError "imageName parameter can't be null"
    fi

    buildCounter=$2
    if [ -z ${buildCounter} ]
    then
        ScreenUtils.echoError "buildCounter parameter can't be null"
    fi

    ScreenUtils.separateLine
    echo "[PUSH] Docker -> $imageName"
    docker push ${imageName}:'latest'
    docker push ${imageName}:${buildCounter}
}

#############################################################################################
##                                  DEPLOY DOCKER
############################################################################################
DockerUtils.deployDocker()
{
    imageName=$1
    if [ -z ${imageName} ]
    then
        ScreenUtils.echoError "imageName parameter can't be null"
    fi
    buildCounter=$2
    if [ -z ${buildCounter} ]
    then
        ScreenUtils.echoError "buildCounter parameter can't be null"
    fi
    deploymentName=$3
    if [ -z ${deploymentName} ]
    then
        ScreenUtils.echoError "deploymentName parameter can't be null"
    fi
    podName=$4
    if [ -z ${podName} ]
    then
        ScreenUtils.echoError "podName parameter can't be null"
    fi
    ScreenUtils.separateLine
    echo "[DEPLOY] Docker -> $imageName"
    echo "kubectl set image deployments/$deploymentName $podName=$imageName:$buildCounter  --namespace=default"
}
