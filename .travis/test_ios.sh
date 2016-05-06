#!/bin/sh

name=${NAME:-$UNOPROJ}
status=0
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
exit $status
