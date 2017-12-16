#!/bin/bash
eval "$(ssh-agent -s)}"

chmod 700 ~/.ssh/
chmod 600 ~/.ssh/id_rsa

git remote add deploy ssh://kommuuniapp@$IP:$PORT$DEPLOY_DIR
git push deploy master

ssh kommuuniapp@$IP -p $PORT -o StrictHostKeyChecking=no<<EOF
    cd $DEPLOY_DIR
    rake db:migrate
EOF