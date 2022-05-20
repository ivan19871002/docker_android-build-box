## Create Image ##

The following Dockerfile will build an Android Build System image based on Ubuntu 20.04 LTS.

It will include a container user that matches the user and group IDs and names of the host user. This ensures correct file system permissions if you bind mount local filesystems for sources and out when running the image.

Additionally, it will also preconfigure your git identity.

    docker build -t android-build-box:focal \
        --build-arg USER_NAME=$USER \
        --build-arg USER_ID=$(id -u) \
        --build-arg GROUP_ID=$(id -g) \
        --build-arg GIT_NAME="<your name>" \
        --build-arg GIT_EMAIL="<your email-address>" \
        --build-arg ROOT_PASSWD="<your root password>" \
        .

If you use mac ,plse use this

    docker build -t android-build-box:focal \
        --build-arg USER_NAME=$USER \
        --build-arg GIT_NAME="<your name>" \
        --build-arg GIT_EMAIL="<your email-address>" \
        --build-arg ROOT_PASSWD="<your root password>" \
	.


This image will expect the following locations to contain :

    /home/sources : sources to compile
    /home/ccache  : ccache
    /home/out     : out folder

## Run Image ##

Use following command to simply run the image :

    docker run --rm -it \
        --privileged \
        -h android-build-box \
        android-build-box:focal \
        bash

Use the following command if you want to bind-mount your local sources, ccache and out folders, as well as your local ssh credentials (read-only) :

    docker run --rm -it \
        --privileged \
        -v ~/.ssh:/home/$USER/.ssh:ro \
        -v <local sources folder>:/home/source \
        -v <local ccache folder>:/home/ccache \
        -v <local out folder>:/home/out \
        -h android-build-box \
        android-build-box:focal \
        bash

Use the following command if you want to bind-mount your local sources and ccache folders, and use a ramdisk for out, as well as your local ssh credentials (read-only) :

    docker run --rm -it \
        --privileged \
        -v ~/.ssh:/home/$USER/.ssh:ro \
        -v <local sources folder>:/home/source \
        -v <local ccache folder>:/home/ccache \
        --tmpfs /home/out:rw,exec,size=92G \
        -h android-build-box \
        android-build-box:focal \
        bash

Note :

* In all cases, the container will be autoremoved on exit, if you want to keep the container, omit "--rm".
* '--privileged' flag is needed to allow nsjail to operate properly (this may become fatal in the future).

## Inspiration and Thanks ##

    https://developer.toradex.com/knowledge-base/how-to-setup-android-build-environment-using-docker
