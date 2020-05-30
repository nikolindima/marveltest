#!/bin/bash
# Set the build number to the current git commit count.
# If we're using the Dev scheme then we'll suffix the build number with the
# current branch name to make collisions far less likely across feature branches.

git=$(sh /etc/profile; which git)
appBuild=$("$git" rev-list HEAD --count)
branchName=$("$git" rev-parse --abbrev-ref HEAD)
dsym_plist="$DWARF_DSYM_FOLDER_PATH/$DWARF_DSYM_FILE_NAME/Contents/Info.plist"
target_plist="$TARGET_BUILD_DIR/$INFOPLIST_PATH"

for plist in "$target_plist" "$dsym_plist"; do
	if [ -f "$plist" ]; then
		if [ $CONFIGURATION = "Debug" ]; then

			/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $appBuild-$branchName" "$plist"
			echo "Build number set to $appBuild-$branchName in ${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

		else

			/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $appBuild" "$plist"
			echo "Build number set to $appBuild in ${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

		fi
	fi

done
