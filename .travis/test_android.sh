#!/bin/sh

name=${NAME:-$UNOPROJ}
echo travis_fold:start:android
uno build -tAndroid -DGRADLE ${UNOPROJ}.unoproj -v
exitcode=$?
echo travis_fold:end:android
if [ $exitcode -ne 0 ]; then
	echo "uno android $name - FAIL"
else
	echo "uno android $name - PASS"
fi
exit $exitcode
