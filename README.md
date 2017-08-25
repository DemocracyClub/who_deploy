# WhoCanIVoteFor build and deploy

## Setup

* `pip install -r requirements.txt`
* Ensure your AWS credentials are in `~/.aws/credentials`
* create `.vault_pass.txt` with your vault password

## Build

* `AWS_PROFILE=wcivf ./packer`

## Deploy

* If we're deploying to production, `export ENVIRONMENT=prod`. Obviously don't do this for a staging deploy!
* `AWS_PROFILE=wcivf ansible-playbook aws.yml -e replace_all=True`
