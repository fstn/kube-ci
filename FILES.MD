# .gitlab-ci.yml
Gitlab build script descriptor.

# .gitlab-ci.config.yml
Contains build configuration for every sub folder
buildAndDeployIfChangesInFolder: folder to scan for changes, if there is changes it run the build
listOfDependencies: folder that must be build if the current folder is build

Example:

    buildAndDeployIfChangesInFolder: \(src/frontends/wecom\)
    listOfDependencies: sources/0-fake-dependencies
    
    before_script:
      - set -e
    
    build-sources:
      script:
       - npm install
       - npm link  ../0-wecom-share
       - npm run-script build
       
# [0-9]*.k.sh

Shell script that are executed based on the first digit order 0 is the first

# [0-9]*.k.yml

Kubernetes deployment file that are executed based on the first digit order 0 is the first
 
# [0-9]*.k.helm.yml
 
Helm deployment file that are executed based on the first digit order 0 is the first

Example:

    helm:
      releaseName: externals-https-validation
      chart: ./src/deployments/1-https-verification
      namespace: gitlab-managed-apps
    ssl:
      verificationKey: xxxxxx
  
Configuration:     

- helm.releaseName = helm release name use to install helm chart
- helm.chart = helm chart folder
- variables: example ssl.verificaitonKey
          
    You can after use {{ .Values.ssl.verificationKey }} in your template like:
    
        {{- $fullName := include "1-https-verification.fullname" . -}}
        apiVersion: v1
        kind: ConfigMap
        metadata:
          namespace: {{.Values.NAMESPACE}}
          name: {{ $fullName }}
        data:
          nginx.conf: |
            events {
            }
            http {
              server {
                listen 80 default_server;
                server_name _;
        
                location / {
                    return 200 'healthy';
                }
        
                location /.well-known/pki-validation/fileauth.txt {
                  return 200 '{{ .Values.ssl.verificationKey }}';
                }
        
              }
            }      

# .deployments.gitlab-ci.yml
Contains the deployment definition for git branch:

    < Branch Name >:
      dns: < DNS Name >
      namespace: < namespace: test,staging,prod >
      
After, you will be able to use variable in you helm template like that:

    hosts:
    - proxy.{{.Values.DNS}}
    
