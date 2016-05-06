#!/bin/sh

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
	echo "Installing Android NDK version ${NDK_VERSION}"
	ls -l /Users/travis/Library/Android/sdk/ndk-bundle/ndk-build
	if [ -x /Users/travis/Library/Android/sdk/ndk-bundle/ndk-build ]; then
		echo "Existing installation"
		exit 0
	fi
	wget http://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-darwin-x86_64.zip
	unzip android-ndk-${NDK_VERSION}-darwin-x86_64.zip | grep -v inflating: | grep -v creating: | grep -v extracting:
	rm android-ndk-${NDK_VERSION}-darwin-x86_64.zip
	mkdir -p "/Users/travis/Library/Android/sdk/"
	rm -rf /Users/travis/Library/Android/sdk/ndk-bundle
	mv android-ndk-${NDK_VERSION} "/Users/travis/Library/Android/sdk/ndk-bundle"
	echo "Installed NDK to /Users/travis/Library/Android/sdk/ndk-bundle"
fi
