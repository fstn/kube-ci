FROM docker:dind
COPY gitlab-useraccount.json .
ENV PATH /google-cloud-sdk/bin:$PATH
RUN apk add --update bash git make ca-certificates openssl  python  python-dev py-pip build-base nodejs wget curl && \
    curl -o helm.tar.gz https://kubernetes-helm.storage.googleapis.com/helm-v2.7.0-linux-amd64.tar.gz && \
    tar xzf helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin && \
    wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz && \
    tar zxvf google-cloud-sdk.tar.gz && /google-cloud-sdk/install.sh --usage-reporting=false --path-update=true && \
    gcloud --quiet components update && \
    gcloud auth activate-service-account --key-file  gitlab-useraccount.json && \
    gcloud auth configure-docker && \
    gcloud components install kubectl && \
    pip install shyaml && \
    npm install && \
    set -o pipefail

