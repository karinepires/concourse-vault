# Concourse with Vault

!!!Important!!! This is NOT production ready, use at your own risk.

Follow the steps at [Concourse docker docs](https://concourse.ci/docker-repository.html).

Run the following to create concourse keys:

```
mkdir -p keys/web keys/worker

ssh-keygen -t rsa -f ./keys/web/tsa_host_key -N ''
ssh-keygen -t rsa -f ./keys/web/session_signing_key -N ''

ssh-keygen -t rsa -f ./keys/worker/worker_key -N ''

cp ./keys/worker/worker_key.pub ./keys/web/authorized_worker_keys
cp ./keys/web/tsa_host_key.pub ./keys/worker
```

Set up the URL:
```
export CONCOURSE_EXTERNAL_URL=http://192.168.99.100:8080
```

Create vault key:
```
mkdir -p keys/vault
ssh-keygen -t rsa -f ./keys/web/vault_key -N ''
cp ./keys/web/vault_key.pub ./keys/vault/authorized_keys
```


Run it up:
```
docker-compose up
```

    