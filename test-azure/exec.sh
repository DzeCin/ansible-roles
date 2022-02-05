#!/bin/bash

set -e

rm=0

for var in "$@"
do
    if [ "$var" == "--rm" ]; then
      rm=1
    fi
done



terraform apply -auto-approve
sleep 4
res=$(python ./format-to-hosts.py "$(terraform output vmip)")
ansible-playbook -u "dzenan" --ssh-common-args='-o StrictHostKeyChecking=no' -i "$res" -v ../main.yml

if [ $rm == 1 ]; then
  terraform destroy -auto-approve
fi