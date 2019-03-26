#!/bin/sh

#  build-script.sh
#
#  Created by Hussein Habibi on 10/11/17.
#  Copyright © 2019 Chabok Realtime Solutions. All rights reserved.

if [ "$JENKINS" = "NO" ]
then
    export CONFIGURATION="Debug"
else
    export CONFIGURATION="Release"
fi

echo "\n\n🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️ BUILD BY JENKINS = $JENKINS 🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️🙎🏻‍♂️\n\n"

###==================================== JENKINS

##CONFIGURATION="Debug"
##CONFIGURATION="Release"

TARGET_NAME="YOUR_PROJECT_NAME"

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

rm -rf "Build"

rm -rf "frameworks"

mkdir "frameworks"

export ALREADYINVOKED="true"

##======================= Build ARM64 ===========================
echo "\n\n📱📱📱📱📱📱 Building ARCH = ARM64 📱📱📱📱📱📱\n\n"

xcodebuild -project "${PROJECT_FILE_PATH}" -target "${PROJECT_NAME}" -configuration "${CONFIGURATION}" -sdk iphoneos BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}" CONFIGURATION_BUILD_DIR="${IPHONE_DEVICE_BUILD_DIR}/arm64" SYMROOT="${SYMROOT}" ARCHS='arm64' VALID_ARCHS='arm64'

cp -r "${IPHONE_DEVICE_BUILD_DIR}/arm64" "frameworks"

cp -r "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/arm64" "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/arm64-"

##======================= Build ARMv7 ===========================
echo "\n\n📱📱📱📱📱📱 Building ARCH = ARMv7 📱📱📱📱📱📱\n\n"

xcodebuild -project "${PROJECT_FILE_PATH}" -target "${PROJECT_NAME}" -configuration "${CONFIGURATION}" -sdk iphoneos BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}"  CONFIGURATION_BUILD_DIR="${IPHONE_DEVICE_BUILD_DIR}/armv7" SYMROOT="${SYMROOT}" ARCHS='armv7' VALID_ARCHS='armv7'

cp -r "${IPHONE_DEVICE_BUILD_DIR}/armv7" "frameworks"

cp -r "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/armv7" "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/armv7-"

##======================= Build ARMv7s ===========================
echo "\n\n📱📱📱📱📱📱 Building ARCH = ARMv7s 📱📱📱📱📱📱\n\n"

xcodebuild -project "${PROJECT_FILE_PATH}" -target "${PROJECT_NAME}" -configuration "${CONFIGURATION}" -sdk iphoneos BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}"  CONFIGURATION_BUILD_DIR="${IPHONE_DEVICE_BUILD_DIR}/armv7s" SYMROOT="${SYMROOT}" ARCHS='armv7s' VALID_ARCHS='armv7s'

cp -r "${IPHONE_DEVICE_BUILD_DIR}/armv7s" "frameworks"

cp -r "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/armv7s" "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/armv7s-"

##======================= Build i386 ===========================
echo "\n\n📱📱📱📱📱📱 Building ARCH = i386 📱📱📱📱📱📱\n\n"

#remove old file
rm -rf "${SIMULATOR_BUILD_DIR}/i386/${PROJECT_NAME}.framework"

xcodebuild -project "${PROJECT_FILE_PATH}" -target "${PROJECT_NAME}" -configuration "${CONFIGURATION}" -sdk iphonesimulator BUILD_DIR="${BUILD_ROOT}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}"  CONFIGURATION_BUILD_DIR="${SIMULATOR_BUILD_DIR}/i386" SYMROOT="${SYMROOT}" ARCHS="i386" VALID_ARCHS="i386"

cp -rf "${SIMULATOR_BUILD_DIR}/i386" "frameworks"

cp -r "Build/Intermediates/${TARGET_NAME}.build/Release-iphonesimulator/${TARGET_NAME}.build/Objects-normal/i386" "Build/Intermediates/${TARGET_NAME}.build/Release-iphonesimulator/${TARGET_NAME}.build/Objects-normal/i386-"

##======================= Build x86_64 ===========================
echo "\n\n📱📱📱📱📱📱 Building ARCH = x86_64 📱📱📱📱📱📱\n\n"

#remove old file
rm -rf "${SIMULATOR_BUILD_DIR}/x86_64/${PROJECT_NAME}.framework"
### Copy the framework structure to the universal folder (clean it first)
#rm -rf "${UNIVERSAL_OUTPUTFOLDER}"
##
#mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

xcodebuild -project "${PROJECT_FILE_PATH}" -target "${PROJECT_NAME}" -configuration "${CONFIGURATION}" -sdk iphonesimulator BUILD_DIR="${BUILD_ROOT}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}"  CONFIGURATION_BUILD_DIR="${SIMULATOR_BUILD_DIR}/x86_64" SYMROOT="${SYMROOT}" ARCHS="x86_64" VALID_ARCHS="x86_64"

cp -rf "${SIMULATOR_BUILD_DIR}/x86_64" "${UNIVERSAL_OUTPUTFOLDER}"

cp -rf "${SIMULATOR_BUILD_DIR}/x86_64" "frameworks"

cp -r "Build/Intermediates/${TARGET_NAME}.build/Release-iphonesimulator/${TARGET_NAME}.build/Objects-normal/x86_64" "Build/Intermediates/${TARGET_NAME}.build/Release-iphonesimulator/${TARGET_NAME}.build/Objects-normal/x86_64-"

if [ "${CONFIGURATION}" = "Release" ]
then
rm -rf "${PWD}/${PROJECT_NAME}.framework"
fi
echo "\n\n🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️ JENKINS combine all architectures $CONFIGURATION 🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️🙋🏻‍♂️\n\n"

rm -rf "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/armv7s"
cp -r "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/armv7s-" "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/armv7s"

rm -rf "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/armv7"
cp -r "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/armv7-" "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/armv7"

rm -rf "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/arm64"
cp -r "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/arm64-" "Build/Intermediates/${TARGET_NAME}.build/Release-iphoneos/${TARGET_NAME}.build/Objects-normal/arm64"

## ======= Simulator ===================
rm -rf "Build/Intermediates/${TARGET_NAME}.build/Release-iphonesimulator/${TARGET_NAME}.build/Objects-normal/i386"
cp -r "Build/Intermediates/${TARGET_NAME}.build/Release-iphonesimulator/${TARGET_NAME}.build/Objects-normal/i386-" "Build/Intermediates/${TARGET_NAME}.build/Release-iphonesimulator/${TARGET_NAME}.build/Objects-normal/i386"

rm -rf "Build/Intermediates/${TARGET_NAME}.build/Release-iphonesimulator/${TARGET_NAME}.build/Objects-normal/x86_64"
cp -r "Build/Intermediates/${TARGET_NAME}.build/Release-iphonesimulator/${TARGET_NAME}.build/Objects-normal/x86_64-" "Build/Intermediates/${TARGET_NAME}.build/Release-iphonesimulator/${TARGET_NAME}.build/Objects-normal/x86_64"

# Smash them together to combine all architectures
lipo -create  "frameworks/i386/${PROJECT_NAME}.framework/${PROJECT_NAME}" "frameworks/x86_64/${PROJECT_NAME}.framework/${PROJECT_NAME}" "frameworks/arm64/${PROJECT_NAME}.framework/${PROJECT_NAME}" "frameworks/armv7/${PROJECT_NAME}.framework/${PROJECT_NAME}" "frameworks/armv7s/${PROJECT_NAME}.framework/${PROJECT_NAME}" -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}"

if [ "${CONFIGURATION}" = "Release" ]
then
    cp -rf "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework" "${PROJECT_DIR}"

    open "${PWD}"
fi
echo  "\n\n✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅\n"

fi
