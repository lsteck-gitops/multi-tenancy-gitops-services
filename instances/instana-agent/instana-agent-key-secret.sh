#!/usr/bin/env bash

# Set variables
if [[ -z ${AGENT_KEY} ]]; then
  echo "Please provide environment variable AGENT_KEY"
  exit 1
fi

SEALED_SECRET_NAMESPACE=${SEALED_SECRET_NAMESPACE:-sealed-secrets}
SEALED_SECRET_CONTOLLER_NAME=${SEALED_SECRET_CONTOLLER_NAME:-sealed-secrets}

# Create Kubernetes Secret yaml

oc create secret generic instana-agent-key \
--from-literal=key=${AGENT_KEY} \
--dry-run=client -o yaml > delete-instana-agent-key-secret.yaml

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal -n instana-agent --controller-name=${SEALED_SECRET_CONTOLLER_NAME} --controller-namespace=${SEALED_SECRET_NAMESPACE} -o yaml < delete-instana-agent-key-secret.yaml > instana-agent-key-secret.yaml

# NOTE, do not check delete-agent-key-secret.yaml into git!
rm delete-instana-agent-key-secret.yaml



