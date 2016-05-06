#!/bin/sh

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
	brew update
	brew outdated node || brew upgrade node
	npm install -g fusepm
fi
