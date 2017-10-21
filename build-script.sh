#!/bin/sh

#  build-script.sh
#
#  Created by Hussein Habibi on 10/11/17.

if [ "$JENKINS" = "NO" ]
then
    export CONFIGURATION="Debug"
else
    export CONFIGURATION="Release"
fi

echo 🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️ BUILD BY JENKINS = $JENKINS 🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️

###==================================== JENKINS

##CONFIGURATION="Debug"
##CONFIGURATION="Release"

TARGET_NAME="MY_PROJECT_NAME"

PROJECT_NAME="${TARGET_NAME}"

PROJECT_FILE_PATH="${PWD}/${PROJECT_NAME}.xcodeproj"

BUILD_DIR="${PWD}/Build"

BUILD_ROOT="${BUILD_DIR}/Products"

SYMROOT="${BUILD_ROOT}"

OBJROOT="${BUILD_DIR}/Intermediates"

IPHONE_DEVICE_BUILD_DIR="${BUILD_ROOT}/${CONFIGURATION}-iphoneos"

SIMULATOR_BUILD_DIR="${BUILD_ROOT}/${CONFIGURATION}-iphonesimulator"

UNIVERSAL_OUTPUTFOLDER="${BUILD_ROOT}/${CONFIGURATION}-universal"

#####============================================================

echo ================== VARIABLES =================

echo PWD = ${PWD}
echo SYMROOT = ${SYMROOT}
echo OBJROOT = ${OBJROOT}
echo BUILD_DIR = ${BUILD_DIR}
echo BUILD_ROOT = ${BUILD_ROOT}
echo TARGET_NAME = ${TARGET_NAME}
echo PROJECT_NAME = ${PROJECT_NAME}
echo CONFIGURATION = ${CONFIGURATION}
echo PROJECT_FILE_PATH = ${PROJECT_FILE_PATH}
echo SIMULATOR_BUILD_DIR = ${SIMULATOR_BUILD_DIR}
echo UNIVERSAL_OUTPUTFOLDER = ${UNIVERSAL_OUTPUTFOLDER}
echo IPHONE_DEVICE_BUILD_DIR = ${IPHONE_DEVICE_BUILD_DIR}

echo ================== VARIABLES =================

#####============================================================

if [ "false" == ${ALREADYINVOKED:-false} ]
then

export ALREADYINVOKED="true"

##======================= Build ARM64 ===========================
echo 📱📱📱📱📱📱 Building ARCH = ARM64 📱📱📱📱📱📱

xcodebuild -project "${PROJECT_FILE_PATH}" -target "${PROJECT_NAME}" -configuration "${CONFIGURATION}" -sdk iphoneos BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}" CONFIGURATION_BUILD_DIR="${IPHONE_DEVICE_BUILD_DIR}/arm64" SYMROOT="${SYMROOT}" ARCHS='arm64' VALID_ARCHS='arm64' $ACTION clean build

##======================= Build ARMv7 ===========================
echo 📱📱📱📱📱📱 Building ARCH = ARMv7 📱📱📱📱📱📱

xcodebuild -project "${PROJECT_FILE_PATH}" -target "${PROJECT_NAME}" -configuration "${CONFIGURATION}" -sdk iphoneos BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}"  CONFIGURATION_BUILD_DIR="${IPHONE_DEVICE_BUILD_DIR}/armv7" SYMROOT="${SYMROOT}" ARCHS='armv7 armv7s' VALID_ARCHS='armv7 armv7s' $ACTION clean build

##======================= Build x86_64 ===========================
echo 📱📱📱📱📱📱 Building ARCH = x86_64 📱📱📱📱📱📱

#remove old file
rm -rf "${SIMULATOR_BUILD_DIR}/${PROJECT_NAME}.framework"
# Copy the framework structure to the universal folder (clean it first)
rm -rf "${UNIVERSAL_OUTPUTFOLDER}"
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

xcodebuild -project "${PROJECT_FILE_PATH}" -target "${PROJECT_NAME}" -configuration "${CONFIGURATION}" -sdk iphonesimulator BUILD_DIR="${BUILD_ROOT}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}"  CONFIGURATION_BUILD_DIR="${SIMULATOR_BUILD_DIR}" SYMROOT="${SYMROOT}" ARCHS="x86_64" VALID_ARCHS="x86_64" $ACTION clean build
### end Simulator###

cp -rf "${SIMULATOR_BUILD_DIR}/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework"

if [ "${CONFIGURATION}" = "Release" ]
then
    rm -rf "${PWD}/${PROJECT_NAME}.framework"
fi
echo 🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️ JENKINS combine all architectures $CONFIGURATION 🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️

# Smash them together to combine all architectures
lipo -create  "${SIMULATOR_BUILD_DIR}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${IPHONE_DEVICE_BUILD_DIR}/arm64/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${IPHONE_DEVICE_BUILD_DIR}/armv7/${PROJECT_NAME}.framework/${PROJECT_NAME}" -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}"

if [ "${CONFIGURATION}" = "Release" ]
then
    cp -rf "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework" "${PROJECT_DIR}"

    open "${PWD}"
fi
echo  ✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅

fi

