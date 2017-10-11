#!/bin/sh

#  build-script.sh
#
#  Created by Hussein Habibi on 10/11/17.
#  Copyright © 2017 AdpDigital. All rights reserved.

#!/bin/sh

if [ "$JENKINS" = "" ] || [ "$JENKINS" = "YES" ]
then

echo 🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️ BUILD BY JENKINS = $JENKINS 🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️

###==================================== JENKINS

###CONFIGURATION="Debug"
CONFIGURATION="Release"

TARGET_NAME="MY PROJECT NAME"

PROJECT_NAME="${TARGET_NAME}"

PROJECT_FILE_PATH="${PWD}/${TARGET_NAME}.xcodeproj"

BUILD_DIR="${PWD}/Build"

BUILD_ROOT="${BUILD_DIR}/Products"

SYMROOT="${BUILD_ROOT}"

OBJROOT="${BUILD_DIR}/Intermediates"

IPHONE_DEVICE_BUILD_DIR="${BUILD_ROOT}/${CONFIGURATION}-iphoneos"

SIMULATOR_BUILD_DIR="${BUILD_ROOT}/${CONFIGURATION}-iphonesimulator"

UNIVERSAL_OUTPUTFOLDER="${BUILD_ROOT}/${CONFIGURATION}-universal"

##======================= Build ARM64 ===========================
if [ "${ARCHS}" = "" ]
then
echo 📱📱📱📱📱📱 Building ARCH = ARM64 📱📱📱📱📱📱

JENKINS=YES

xcodebuild -project "${PROJECT_FILE_PATH}" -target "${PROJECT_NAME}" -configuration "${CONFIGURATION}" -sdk iphoneos BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}" CONFIGURATION_BUILD_DIR="${IPHONE_DEVICE_BUILD_DIR}/arm64" SYMROOT="${SYMROOT}" ARCHS='arm64' VALID_ARCHS='arm64' $ACTION clean build

JENKINS=YES
fi

##======================= Build ARMv7 ===========================
if [ "${ARCHS}" = "arm64" ]
then

echo 📱📱📱📱📱📱 Building ARCH = ARMv7 📱📱📱📱📱📱

JENKINS=YES

xcodebuild -project "${PROJECT_FILE_PATH}" -target "${PROJECT_NAME}" -configuration "${CONFIGURATION}" -sdk iphoneos BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}"  CONFIGURATION_BUILD_DIR="${IPHONE_DEVICE_BUILD_DIR}/armv7" SYMROOT="${SYMROOT}" ARCHS='armv7 armv7s' VALID_ARCHS='armv7 armv7s' $ACTION clean build

JENKINS=YES

fi

##======================= Build x86_64 ===========================
if [ "${ARCHS}" = "armv7 armv7s" ]
then
echo 📱📱📱📱📱📱 Building ARCH = x86_64 📱📱📱📱📱📱

JENKINS=YES

#remove old file
rm -rf "${SIMULATOR_BUILD_DIR}/${PROJECT_NAME}.framework"
# Copy the framework structure to the universal folder (clean it first)
rm -rf "${UNIVERSAL_OUTPUTFOLDER}"
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

xcodebuild -project "${PROJECT_FILE_PATH}" -target "${PROJECT_NAME}" -configuration "${CONFIGURATION}" -sdk iphonesimulator BUILD_DIR="${BUILD_ROOT}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}"  CONFIGURATION_BUILD_DIR="${SIMULATOR_BUILD_DIR}" SYMROOT="${SYMROOT}" ARCHS="x86_64" VALID_ARCHS="x86_64" $ACTION clean build
### end Simulator###

JENKINS=YES

cp -rf "${SIMULATOR_BUILD_DIR}/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework"

rm -rf "${PWD}/${PROJECT_NAME}.framework"

# Smash them together to combine all architectures
lipo -create  "${SIMULATOR_BUILD_DIR}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${IPHONE_DEVICE_BUILD_DIR}/arm64/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${IPHONE_DEVICE_BUILD_DIR}/armv7/${PROJECT_NAME}.framework/${PROJECT_NAME}" -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}"

cp -rf "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework" "${PROJECT_DIR}"

echo 🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️ JENKINS combine all architectures 🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️

open "${PWD}"

echo 🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️ JENKINS BUILDED x86_64 🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️

elif [ "${ARCHS}" = "x86_64" ]
then

echo 🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️ JENKINS BUILDING x86_64 🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️

else

echo  ✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅

fi

else

echo 🖥🖥🖥🖥🖥🖥 BUILD by XCODE 🖥🖥🖥🖥🖥🖥🖥

#=========================== Build with xCode ==========

UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal

# make sure the output directory exists
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

# Next, work out if we're in SIM or DEVICE
if [ "false" == ${ALREADYINVOKED:-false} ]
then

export ALREADYINVOKED="true"

if [ ${PLATFORM_NAME} = "iphonesimulator" ]
then
xcodebuild -target "${PROJECT_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
else
xcodebuild -target "${PROJECT_NAME}" -configuration ${CONFIGURATION} -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
fi

# Step 2. Copy the framework structure (from iphoneos build) to the universal folder
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

# Step 3. Copy Swift modules from iphonesimulator build (if it exists) to the copied framework directory
SIMULATOR_SWIFT_MODULES_DIR="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/."
if [ -d "${SIMULATOR_SWIFT_MODULES_DIR}" ]; then
cp -R "${SIMULATOR_SWIFT_MODULES_DIR}" "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule"
fi

# Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework/${PROJECT_NAME}"

# Step 5. Convenience step to copy the framework to the project's directory
#rm -rf "${PROJECT_DIR}/${PROJECT_NAME}/${PROJECT_NAME}.framework"
cp -rf "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework" "${PROJECT_DIR}"

# Step 6. Convenience step to open the project's directory in Finder
open "${PROJECT_DIR}"

fi
fi
