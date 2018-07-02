## Enable legacy login on Google Cloud Kubernetes Cluster
## Create gitlab service account
    cat > /tmp/serviceaccount.yaml <<EOF
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: build-robot
    automountServiceAccountToken: false
    EOF
    kubectl create -f /tmp/serviceaccount.yaml

    cat > /tmp/build-robot-secret.yaml <<EOF
    apiVersion: v1
    kind: Secret
    metadata:
      name: build-robot-secret
      annotations:
        kubernetes.io/service-account.name: build-robot
    type: kubernetes.io/service-account-token
    EOF
    kubectl create -f /tmp/build-robot-secret.yaml
## Get token
    kubectl describe secrets/build-robot-secret
