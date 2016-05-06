#!/bin/sh

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
	brew update
	brew install node
	npm install -g fusepm
fi
