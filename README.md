# kube-ci
ci bridge between kubernetes and Gitlab.
Build and deploy a easy CI with gitLab and Kubernetes

- Detect changes in subfolder
- Build sources
- Build docker
- Deploy with Helm

See demo folder

## How to use it

In your gitlab-ci.yml file:
```
before_script:
  - set -e
  - wget https://github.com/fstn/kube-ci/raw/master/kubeci.tar --no-cache
  - tar xvf kubeci.tar
  - mv ./kubeci /
  - chmod +x /kubeci/kubeci
  - export KUBECI_PATH=/kubeci
  - export NODE_ENV="development"
  
build-sources:
  stage: build
  script:
  - bash /kubeci/kubeci -bs -bd -d -p=wecom-205708 -bi=$CI_PIPELINE_ID -s=$(pwd)

build-all:
  stage: build
  script:
   - bash /kubeci/kubeci -bs -bd -d -a -p=wecom-205708 -bi=$CI_PIPELINE_ID -s=$(pwd)
  when: manual

deploy-all:
  stage: deploy
  script:
   - bash /kubeci/kubeci -d -a -p=wecom-205708 -bi=881 -s=$(pwd)
  when: manual

delete-staging-all:
  stage: test
  script:
   - kubectl delete services,statefulsets,deployments,po --all --namespace=staging
  when: manual
```

Add a .gitlab-ci.config.yml file in you subfolder (see files description for more information)

### How to run ?
```
$YOUR_INSTALLATION_PATH/kube-ci/kube-ci/kubeci -bs -p=test -bi=1
```

bi represent the image tag number, each image will be also push using namespace as tag

### How to build ?
```
$YOUR_INSTALLATION_PATH/kube-ci/build.sh
```

## Requirements

### Docker image
   
    Docker image URL
   
    
### Kubernetes initial deployment configuration

#### To use the script on your laptop:
1) gcloud container clusters get-credentials we-1 --zone europe-west2-a --project test-we
2) Add a .kube/config with the content of the config on the server


## Files descriptor
[Files](FILES.MD)

## Requirements
[Requirements](REQUIREMENTS.MD)

## GitLab Requirements
[GitLab requirements](GITLAB.MD)

## Run Demo

export CI_COMMIT_REF_NAME=master
export KUBECI_PATH=../kubeci
cd demo
 bash ../kubeci/kubeci -bs -bd -d -p=test -bi=1 -s=$(pwd)
