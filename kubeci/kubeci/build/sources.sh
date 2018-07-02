#!/bin/sh

set -e

. ${KUBECI_PATH}/shell-utils/screen-utils.sh
. ${KUBECI_PATH}/shell-utils/git-utils.sh

#############################################################################################
##                                  BUILD
#############################################################################################
build()
{
    ScreenUtils.echoBanner "BUILD"
    echo "[START] build files inside -> $1"
    for f in `find $1 -regex ".*/.gitlab-ci.config.yml"| sort -n `; do
        echo "[APPLY] file -> $f"
        export f=${f}
        cd $(dirname ${f})
        action(){
            # Run all build script define in yaml file
            done=0
            cat ${f} | shyaml get-values-0 "build-sources.script" 2>/dev/null |
              while IFS='' read -r -d '' value; do
                    echo "[PROGRESS] $value"
                    ${value}
                    done=1
              done
            if [ ${done} -eq 0 ]
            then
            echo "[IGNORING] build file ->  ${f}"
            fi
        }
        GitUtils.doIfChangesDetected ${f} action
    done
    echo "[COMPLETED] build files -> $1"
}

build  $(pwd)

