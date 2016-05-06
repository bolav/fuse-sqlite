#!/bin/sh

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
	echo "Installing Android NDK version ${NDK_VERSION}"
	wget http://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-darwin-x86_64.zip
	unzip android-ndk-${NDK_VERSION}-darwin-x86_64.zip | grep -v inflating: | grep -v creating: | grep -v extracting:
	rm android-ndk-${NDK_VERSION}-darwin-x86_64.zip
	mkdir -p "/Users/travis/Library/Android/sdk/"
	mv android-ndk-${NDK_VERSION} "/Users/travis/Library/Android/sdk/ndk-bundle"
	echo "Installed NDK to /Users/travis/Library/Android/sdk/ndk-bundle"
fi
