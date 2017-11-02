# Concourse with Vault

!!!Important!!! This is NOT production ready, use at your own risk.

Follow the steps at [Concourse docker docs](https://concourse.ci/docker-repository.html).

Clone the project and build docker image:
```
git clone https://github.com/karinepires/concourse-vault.git
cd concourse-vault
docker build -f concourse-web/dockerfile ./concourse-web/ -t concourse-web
```

Run the following to create concourse keys:

```
mkdir -p keys/web keys/worker

ssh-keygen -t rsa -f ./keys/web/tsa_host_key -N ''
ssh-keygen -t rsa -f ./keys/web/session_signing_key -N ''

ssh-keygen -t rsa -f ./keys/worker/worker_key -N ''

cp ./keys/worker/worker_key.pub ./keys/web/authorized_worker_keys
cp ./keys/web/tsa_host_key.pub ./keys/worker
```

Set up the concourse URL:
```
export CONCOURSE_EXTERNAL_URL=http://192.168.99.100:8080
```

Create vault key:
```
mkdir -p keys/vault
ssh-keygen -t rsa -f ./keys/web/vault_key -N ''
cp ./keys/web/vault_key.pub ./keys/vault/authorized_keys

export CONCOURSE_VAULT_ROOT_TOKEN_ID=my_secret_token
```


Run it up:
```
docker-compose up -d
```

Set up with vault CLI the credentials your pipeline uses, as explained at [concourse cred docs](https://concourse.ci/creds.html).

For a ((foo_param)) variable in the `pipeline.yml`:
```
export VAULT_ADDR=http://your-concourse-vault-ip:8200
vault auth concourse
vault write /concourse/TEAM_NAME/PIPELINE_NAME/foo_param value=MY_FOO_VALUE
```

TODOS:
* Create vault tokens that can only read (concourse one), and write (developer one, probably with the github auth).
* Make the vault secrets persistent with docker volumes