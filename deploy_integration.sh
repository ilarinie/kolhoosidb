#!/bin/bash
eval "$(ssh-agent -s)}"
chmod 600 .travis/id_rsa
ssh-add .travis/id_rsa

git config --global push.default matching
git remote add deploy ssh://ile@$IP:$PORT$DEPLOY_DIR
git push deploy master

ssh ile@$IP -p $PORT <<EOF
    cd $DEPLOY_DIR
    rake db:migrate
EOF