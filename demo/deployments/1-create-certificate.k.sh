#!/bin/sh
cd "$(dirname "$0")"
exists=$(kubectl get secrets web-secret --ignore-not-found --namespace=${NAMESPACE}  | wc -l)
if [ $exists -gt 1 ]
then
    echo "secret already exists"
else
    kubectl create secret tls web-secret  --cert=externals.crt --key=externals.pk --namespace=${NAMESPACE}
fi
