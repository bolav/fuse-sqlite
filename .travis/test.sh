#!/bin/sh

name=${UNOPROJ}
status=0
echo travis_fold:start:uno
uno build ${UNOPROJ}.unoproj -v
exitcode=$?
echo travis_fold:end:uno
if [ $exitcode -ne 0 ]; then
	echo "uno $name - FAIL"
	status=$exitcode
else
	echo "uno $name - PASS"
fi
echo travis_fold:start:ios
uno build -tiOS ${UNOPROJ}.unoproj -v -N
exitcode=$?
cd build/iOS/Debug
xcodebuild -project $name.xcodeproj CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
exitcode2=$?
cd ../../..
echo travis_fold:end:ios
if [ $exitcode -ne 0 ]; then
	echo "uno ios $name - FAIL"
	status=$exitcode
else
	echo "uno ios $name - PASS"
fi
if [ $exitcode2 -ne 0 ]; then
	echo "uno ios xcodebuild $name - FAIL"
	status=$exitcode2
else
	echo "uno ios xcodebuild $name - PASS"
fi
echo travis_fold:start:android
uno build -tAndroid ${UNOPROJ}.unoproj -v
exitcode=$?
echo travis_fold:end:android
if [ $exitcode -ne 0 ]; then
	echo "uno android $name - FAIL"
	status=$exitcode
else
	echo "uno android $name - PASS"
fi
exit $status
