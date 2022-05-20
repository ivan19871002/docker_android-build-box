#!/bin/sh
rm Dockerfile
cp Dockerfile-ubuntu Dockerfile

docker build -t android-build-box:focal \
        --build-arg USER_NAME=$USER \
        --build-arg USER_ID=$(id -u) \
        --build-arg GROUP_ID=$(id -g) \
        --build-arg GIT_NAME="echo $(git config --get user.name)" \
        --build-arg GIT_EMAIL="echo $(git config --get user.email)" \
        --build-arg ROOT_PASSWD="12345678" \
		.