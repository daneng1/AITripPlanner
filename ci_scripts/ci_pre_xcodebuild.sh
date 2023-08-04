#!/bin/sh

#  ci_pre_xcodebuild.sh
#  AITripPlanner
#
#  Created by Dan and Beth Engel on 8/3/23.
#

echo "Stage: PRE-Xcode Build is activated .... "

# Move to the place where the scripts are located.
# This is important because the position of the subsequently mentioned files depend of this origin.
#cd ../ci_scripts || exit 1

# Write a JSON File containing all the environment variables and secrets.
printf "{\"OPEN_AI_KEY\":\"%s\",\"UNSPLASH_ACCESS_KEY\":\"%s\"}" "$OPEN_AI_KEY" "$UNSPLASH_ACCESS_KEY" >> ../Secrets.json

echo "Wrote Secrets.json file."

echo "Stage: PRE-Xcode Build is DONE .... "

exit 0
