#!/bin/bash
set -e

PACKAGE=MurMurHash

if [[ $# -ne 2 ]] ; then
   echo 'Usage:  sh buildRpm <BUILD_TYPE> <BUILD_NUMBER>'
   echo '        BUILD_TYPE is PRODUCTION or DEBUG'
   exit 0
fi

if [ "$1" = "PRODUCTION"  ] ; then
   BUILD_TYPE="-DUSE_LR_DEBUG=OFF"
elif  [ "$1" = "DEBUG"  ] ; then
   BUILD_TYPE="-DUSE_LR_DEBUG=ON"
else
   echo "<BUILD_TYPE> must be one of: PRODUCTION or DEBUG"
   exit 0
fi

BUILD="$2"

PWD=`pwd`
CWD=$PWD/$PACKAGE
DISTDIR=$CWD/dist/$PACKAGE
PATH=$PATH:/usr/local/probe/bin:$PATH

GIT_VERSION=`git rev-list --branches HEAD | wc -l`
VERSION="1.$GIT_VERSION"


rpmdev-setuptree
cp packaging/$PACKAGE.spec ~/rpmbuild/SPECS
rm -f $PACKAGE-$VERSION.tar.gz
tar czf $PACKAGE-$VERSION.tar.gz ./*
cp $PACKAGE-$VERSION.tar.gz ~/rpmbuild/SOURCES
cd ~/rpmbuild
rpmbuild -v -bb --define="version ${VERSION}" --define="buildtype ${BUILD_TYPE}" --define="buildnumber ${BUILD}"  --target=x86_64 ~/rpmbuild/SPECS/$PACKAGE.spec

# Copy the artifacts to the local distribution directory
rm -rf $DISTDIR
mkdir -p $DISTDIR/include/
cp -r ~/rpmbuild/BUILD/$PACKAGE/src/*.h $DISTDIR/include
mkdir -p $DISTDIR/lib/
cp -r ~/rpmbuild/BUILD/$PACKAGE/*.so $DISTDIR/lib
