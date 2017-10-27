#!/usr/bin/env bash

# create a token
VAULT_RESULT=$(ssh concourse-vault "vault auth -address=$CONCOURSE_VAULT_ADDR $CONCOURSE_VAULT_ROOT_TOKEN && vault token-create -id \"concourse\" -renewable=true -ttl=\"1h\"")

# export the token
client_token=$(echo $VAULT_RESULT | grep "accessor" | cut -f2)

export CONCOURSE_VAULT_CLIENT_TOKEN=$client_token

echo $client_token > ~/client_token

# create a concourse mount to handle the concourse secrets
# care when persistence comes by
ssh concourse-vault "vault auth -address=$CONCOURSE_VAULT_ADDR $CONCOURSE_VAULT_ROOT_TOKEN && vault mount -address=$CONCOURSE_VAULT_ADDR -path=concourse kv"

# start web
concourse web