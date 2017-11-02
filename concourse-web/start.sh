#!/usr/bin/env bash

# login
vault auth $CONCOURSE_VAULT_ROOT_TOKEN

# create a token
vault token-create -id "concourse" -renewable=true -ttl="1h"

export CONCOURSE_VAULT_CLIENT_TOKEN=concourse

# create a concourse mount to handle the concourse secrets
# TODO: take care when persistence comes by
vault mount -path=concourse kv

# start web
concourse web