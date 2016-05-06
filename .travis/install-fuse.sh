#!/bin/sh

# https://docs.travis-ci.com/user/multi-os/
# https://docs.travis-ci.com/user/osx-ci-environment/

# http://apple.stackexchange.com/questions/72226/installing-pkg-with-terminal

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
	# In /Users/travis/build/bolav/fuse-travis
	echo "Installing Fuse version ${FUSE_VERSION}"
	wget https://api.fusetools.com/fuse-release-management/releases/${FUSE_VERSION}/osx
	mv osx fuse_osx_${FUSE_VERSION}.pkg
	sudo installer -pkg fuse_osx_${FUSE_VERSION}.pkg -target /
	echo "Installed Fuse"
	fuse install android < ./.travis/sdkinstall.txt
fi
