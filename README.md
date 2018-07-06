# kube-ci
ci bridge between kubernetes and Gitlab

## How to use it

```
wget 
tar -xf kube-ci.tar 
YOUR_INSTALLATION_PATH=/Applications/
mv kube-ci $YOUR_INSTALLATION_PATH/
chmod +x $YOUR_INSTALLATION_PATH/kubeci
export KUBECI_PATH=$YOUR_INSTALLATION_PATH
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
   
### Manual requirements
    
    - Git
    - Kubectl
    - GCloud
    - Bash
    - shyaml
    
    
### Kubernetes initial deployment configuration

#### To use the script on your laptop:
1) gcloud container clusters get-credentials we-1 --zone europe-west2-a --project test-we
2) Add a .kube/config with the content of the config on the server