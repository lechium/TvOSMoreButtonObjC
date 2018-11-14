#!/bin/bash

#SIM="iphonesimulator"
#OS="iphoneos"
SIM="appletvsimulator"
OS="appletvos"

#xcodebuild -sdk iphonesimulator
#xcodebuild -sdk iphoneos

if [ -d "build" ]; then
    echo "removing old build folder..."
    rm -rf build
fi

xcodebuild -sdk $SIM
xcodebuild -sdk $OS

pwd=`pwd`
lipo=`which lipo`
#cd build/Release-iphoneos

RLS_PATH="build/Release-$OS"

echo "$RLS_PATH"

pushd $RLS_PATH

echo $pwd

for i in `find * -name '*.framework'`; do

name=${i%\.*}
echo $name

done

#for i in *.framework ; do
#name=${i%\.*}
#echo $name
#echo "in here?"
#done

#echo $name
outputfile=$name.framework/$name
uniname=$outputfile.uni
fwpath=$pwd/build/Release-$OS/$name.framework
incpath=$pwd/build/Release-$OS/include
fullpath=$pwd/build/Release-$OS/$uniname

echo "####"
echo "outputfile: $outputfile"
echo "uniname: $uniname"
echo "fwpath: $fwpath"
echo "incpath: $incpath"
echo "fullpath: $fullpath"
echo "####"

if [ -z "$name" ]; then

echo "empty name??"

for i in `find * -type f -name '*.a'`; do

name=${i%\.*}
echo $name

done

outputfile=$name.a
uniname=$outputfile.uni
fwpath=$pwd/build/Release-$OS/$name.a
incpath=$pwd/build/Release-$OS/include
fullpath=$pwd/build/Release-$OS/$uniname

fi

lipocmd="$lipo -create $outputfile ../Release-$SIM/$outputfile -output $uniname"
echo $lipocmd
$lipocmd
echo $fullpath
chmod +x $uniname

if [ -f $fullpath ]; then

rm $outputfile
mv $uniname $outputfile
mv $fwpath ../..

if [ -d $incpath ]; then

    echo "found include path: $incpath"
    cp -r $incpath ../..

fi

echo "done!"

else

echo "The file does not exist";

fi



