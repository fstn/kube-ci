#!/bin/sh

ipExists=$(gcloud compute addresses  list --filter="name=('${NAMESPACE}-externals-ip')" | wc -l)
if [ $ipExists -gt 1 ]
then
    echo "Ip ${NAMESPACE}-externals-ip already exists"
else
    gcloud compute addresses create "${NAMESPACE}-externals-ip" --global
fi