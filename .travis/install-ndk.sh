#!/bin/sh

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
	echo $NDK_VERSION
	wget http://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-darwin-x86_64.zip
	unzip android-ndk-${NDK_VERSION}-darwin-x86_64.zip | grep -v inflating: | grep -v creating: | grep -v extracting:
	rm android-ndk-${NDK_VERSION}-darwin-x86_64.zip
	export ANDROID_NDK=${PWD}/android-ndk-${NDK_VERSION}
	export ANDROID_NDK_HOME=${PWD}/android-ndk-${NDK_VERSION}
	export PATH=${PATH}:${ANDROID_NDK_HOME}
	echo "Installed NDK to $ANDROID_NDK_HOME"
	mkdir -p "/Users/travis/Library/Android/sdk/"
	mv android-ndk-${NDK_VERSION} "/Users/travis/Library/Android/sdk/ndk-bundle"
	ls -l /Users/travis/Library/Android/sdk/ndk-bundle
fi
