#!/usr/bin/env bash
set -xe
[ "$CI_BUILD_REF_NAME" = "" ] && CI_BUILD_REF_NAME=$(git symbolic-ref --short -q HEAD)

if [ "$CI_BUILD_REF_NAME" = "unicef" ]; then
    docker login -e="$DOCKER_EMAIL" -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
    docker push institutotim/zup-web:$CI_BUILD_REF_NAME
    mkdir -p ~/.ssh
    SSH_DEPLOY_KEY=~/.ssh/id_rsa
    openssl aes-256-cbc -K $encrypted_b1f0a4911acd_key -iv $encrypted_b1f0a4911acd_iv -in .travis/deploy_key.enc -out $SSH_DEPLOY_KEY -d
    chmod 600 $SSH_DEPLOY_KEY
    ssh -i $SSH_DEPLOY_KEY -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $DEPLOY_TARGET "docker pull institutotim/zup-web:$CI_BUILD_REF_NAME; supervisorctl restart zup-web"
    cleanup
fi