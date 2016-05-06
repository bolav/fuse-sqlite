#!/bin/sh

# https://docs.travis-ci.com/user/multi-os/
# https://docs.travis-ci.com/user/osx-ci-environment/

# http://apple.stackexchange.com/questions/72226/installing-pkg-with-terminal

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
	# In /Users/travis/build/bolav/fuse-travis
	echo "Installing Fuse version ${FUSE_VERSION}"
	ls -l /Applications/Fuse.app/Contents/Uno/uno.exe
	echo "fuse/sdk"
	cat ~/.fuse/sdkConfig.json
	if [ -x /Applications/Fuse.app/Contents/Uno/uno.exe ]; then
		echo "Existing installation"
		cat  ~/.fuse/fuse_version
		sudo cp ./.travis/files/uno /usr/local/bin/uno
		exit 0
	fi
	wget https://api.fusetools.com/fuse-release-management/releases/${FUSE_VERSION}/osx
	mv osx fuse_osx_${FUSE_VERSION}.pkg
	sudo installer -pkg fuse_osx_${FUSE_VERSION}.pkg -target /
	echo "Installed Fuse ${FUSE_VERSION}"
	mkdir -p $HOME/.fuse
	echo ${FUSE_VERSION} > $HOME/.fuse/fuse_version
fi
