#!/bin/bash
chmod 700 ~/.ssh/
chmod 600 ~/.ssh/id_rsa
rm ~/.ssh/known_hosts

ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" kommuuniapp@$IP -p $PORT /home/kommuuniapp/bin/deploy_integration.sh