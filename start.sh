#!/bin/bash

cd ~

curl 10.1.1.254/cloudAccounts > cloudAccounts.json

export AWS_ACCESS_KEY_ID=$(jq -r '.cloudAccounts[].apiKey' < ./cloudAccounts.json)
export AWS_SECRET_ACCESS_KEY=$(jq -r '.cloudAccounts[].apiSecret' < ./cloudAccounts.json)

export TF_VAR_AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export TF_VAR_AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export TF_VAR_AWS_ACCCOUNT_ID=$(jq -r '.cloudAccounts[].accountId' < ./cloudAccounts.json)
export TF_VAR_AWS_CONSOLE_LINK=$(printf https://${TF_VAR_AWS_ACCCOUNT_ID}.signin.aws.amazon.com/console)
export TF_VAR_AWS_USER=$( jq -r '.cloudAccounts[].consoleUsername' < ./cloudAccounts.json)
export TF_VAR_AWS_PASSWORD="$(jq -r '.cloudAccounts[].consolePassword' < ./cloudAccounts.json)"

envsubst < ./config.template > ~/.aws/config
 
printf "AWS Console URL:\n"
printf "${TF_VAR_AWS_CONSOLE_LINK}\n\n"
printf "AWS Console Username:\n"
printf "${TF_VAR_AWS_USER}\n\n"
printf "AWS Console Password:\n"
printf "%s\n\n" ${TF_VAR_AWS_PASSWORD}

envsubst < ./aws-console.template > /mnt/c/Users/Administrator/Desktop/"Amazon Web Services Sign-In.url"

if [ $? -eq 0 ]
then
  echo "The script ran ok"
else
  echo "The script failed" >&2
fi
