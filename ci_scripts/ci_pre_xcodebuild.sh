#!/bin/sh

#  ci_pre_xcodebuild.sh
#  AITripPlanner
#
#  Created by Dan and Beth Engel on 8/3/23.
#  

echo "Stage: PRE-Xcode Build is activated .... "

# for future reference
# https://developer.apple.com/documentation/xcode/environment-variable-reference

cd ../AITripPlanner/

plutil -replace OPENAI_API_KEY -string $OPENAI_API_KEY Info.plist
plutil -replace UNSPLASH_ACCESS_KEY -string $UNSPLASH_ACCESS_KEY Info.plist

plutil -p Info.plist

echo "Stage: PRE-Xcode Build is DONE .... "

exit 0
