#!/bin/bash
eval "$(ssh-agent -s)}"
chmod 600 ~/.ssh/id_rsa
ssh-add ~/.ssh/id_rsa

git remote add deploy ssh://kommuuniapp@$IP:$PORT$DEPLOY_DIR
git push deploy master

ssh ile@$IP -p $PORT <<EOF
    cd $DEPLOY_DIR
    rake db:migrate
EOF