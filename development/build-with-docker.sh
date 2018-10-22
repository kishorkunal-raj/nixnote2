#!/bin/bash
PROJECTBRANCH=${1}
PROJECTDIR=`pwd`

DOCKERMODIFIER=_qt562
DOCKERTAG=nixnote2/xenial${DOCKERMODIFIER}
DOCKERFILE=./development/docker/Dockerfile.ubuntu_xenial${DOCKERMODIFIER}

if [ ! -f src/main.cpp ]; then
  echo "You seem to be in wrong directory. script MUST be run from the project directory."
  exit 1
fi

if [ -z "${PROJECTBRANCH}" ]; then
    PROJECTBRANCH=master
fi

cd $PROJECTDIR
# create "builder" image
docker build -t ${DOCKERTAG} -f ${DOCKERFILE} ./development/docker

# uncommend to stop after creating the image (e.g. you want to do the build manually)
#exit 1

if [ ! -d appdir ] ; then
  mkdir appdir
fi

# delete appdir content
rm -rf appdir/*

BUILD_TYPE=release

if [ ! -d docker-build-${BUILD_TYPE} ]; then
  mkdir docker-build-${BUILD_TYPE}
fi

# start container (note: each call creates new container)



# to try manually:
#   DOCKERTAG=..
#   docker run --rm  -it ${DOCKERTAG} /bin/bash
#    then
#      PROJECTBRANCH=feature/rc1
#      BUILD_TYPE=release
#      ...copy command from bellow & paste..
# --------------------

# for beineri PPA add: source /opt/qt*/bin/qt*-env.sh

time docker run \
   --rm \
   -v $PROJECTDIR/appdir:/opt/nixnote2/appdir \
   -v $PROJECTDIR/docker-build-${BUILD_TYPE}:/opt/nixnote2/qmake-build-${BUILD_TYPE} \
   -v $PROJECTDIR/docker-build-${BUILD_TYPE}-t:/opt/nixnote2/qmake-build-${BUILD_TYPE}-t \
   -it ${DOCKERTAG} \
      /bin/bash -c "cd nixnote2 && git fetch && git checkout $PROJECTBRANCH && git pull  && ./development/build-with-qmake.sh ${BUILD_TYPE} noclean /usr/lib/nixnote2/tidy && ./development/run-tests.sh ${BUILD_TYPE} noclean /usr/lib/nixnote2/tidy && ./development/create-AppImage.sh && mv *.AppImage appdir && chmod -R a+rwx appdir"

ls appdir/*.AppImage
echo "If all got well then AppImage file in appdir is your binary"

cd $PROJECTDIR
