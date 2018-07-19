# kube-ci
ci bridge between kubernetes and Gitlab.

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

### How to run ?
```
$YOUR_INSTALLATION_PATH/kube-ci/kube-ci/kubeci -bs -p=test -bi=1
```

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