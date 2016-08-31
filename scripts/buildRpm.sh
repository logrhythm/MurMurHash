#!/bin/bash
set -e

PACKAGE=MurMurHash

if [[ $# -lt 1 ]] ; then
    echo 'Usage:  sh buildRpm <BUILD_NUMBER>'
    exit 0
fi

BUILD="$1"

PWD=`pwd`
CWD=$PWD/$PACKAGE
DISTDIR=$CWD/dist/$PACKAGE
PATH=$PATH:/usr/local/probe/bin:$PATH

GIT_VERSION=`git rev-list --branches HEAD | wc -l`
VERSION="1.$GIT_VERSION"


rm -rf ~/rpmbuild
rpmdev-setuptree
cp packaging/$PACKAGE.spec ~/rpmbuild/SPECS
rm -f $PACKAGE-$VERSION.tar.gz
tar czf $PACKAGE-$VERSION.tar.gz ./*
cp $PACKAGE-$VERSION.tar.gz ~/rpmbuild/SOURCES
cd ~/rpmbuild
rpmbuild -v -bb --define="version ${VERSION}" --define="buildnumber ${BUILD}"  --target=x86_64 ~/rpmbuild/SPECS/$PACKAGE.spec

# Copy the artifacts to the local distribution directory
rm -rf $DISTDIR
mkdir -p $DISTDIR/include/
cp -r ~/rpmbuild/BUILD/$PACKAGE/src/*.h $DISTDIR/include
mkdir -p $DISTDIR/lib/
cp -r ~/rpmbuild/BUILD/$PACKAGE/*.so $DISTDIR/lib
