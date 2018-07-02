# .gitlab-ci.yml
Gitlab build script descriptor

# .gitlab-ci.config.yml
Contain build configuration for every sub folder
buildAndDeployIfChangesInFolder: folder to scan for changes, if there is changes it run the build

# [0-9]*.k.sh

Shell script that are executed based on the first digit order 0 is the first

# [0-9]*.k.yml

Kubernetes deployment file that are executed based on the first digit order 0 is the first
 
# [0-9]*.k.helm.yml
 
Helm deployment file that are executed based on the first digit order 0 is the first