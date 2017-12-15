#!/bin/bash
eval "$(ssh-agent -s)}"

git remote add deploy ssh://kommuuniapp@$IP:$PORT$DEPLOY_DIR
git push deploy master

ssh kommuuniapp@$IP -p $PORT <<EOF
    yes
    cd $DEPLOY_DIR
    rake db:migrate
EOF