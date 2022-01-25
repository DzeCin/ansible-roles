#!/bin/bash

rm=0

for var in "$@"
do
    if [ "$var" == "--rm" ]; then
      rm=1
    fi
done



terraform apply -auto-approve

if [ $? == 0 ]; then
  res=$(python ./format-to-hosts.py "$(terraform output vmip)")
  ansible-playbook -u "dzenan" --ssh-common-args='-o StrictHostKeyChecking=no' -i "$res" -v ../main.yml
else
  echo 'Error'
  exit 1
fi

if [ $rm == 1 ]; then
  terraform destroy -auto-approve
fi