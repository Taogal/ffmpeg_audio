#!/bin/bash
set -e

#
# This script is used to build ffmpeg lib and sdl2.0 lib.
# 
TOP_ROOT=`pwd`
echo $TOP_ROOT


if [ ! -f "ffmpeg-4.0.2.tar.bz2" ];then
	wget https://ffmpeg.org/releases/ffmpeg-4.0.2.tar.bz2
fi

if [ ! -f "SDL-2.0.9-12272.tar.gz" ];then
	wget http://www.libsdl.org/tmp/SDL-2.0.9-12272.tar.gz 
fi

function build_ffmpeg()
{
	cd $TOP_ROOT/components
	if [ ! -d "ffmpeg-4.0.2" ];then
		cp -rf ../ffmpeg-4.0.2.tar.bz2 .
		tar -vxf ffmpeg-4.0.2.tar.bz2
		rm ffmpeg-4.0.2.tar.bz2
	else
		echo "ffmpeg-4.0.2 dir is existing"
	fi
	
	cd ffmpeg-4.0.2
	apt-get install yasm libxvidcore-dev libvorbis-dev libopencore-amrwb-dev libopencore-amrnb-dev libmp3lame-dev
	
	./configure --prefix=$PWD/tmp --enable-libmp3lame --enable-libvorbis --enable-gpl --enable-version3 --enable-nonfree --enable-pthreads --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libx264 --enable-libxvid --enable-postproc --enable-ffplay --enable-shared
    
	make -j8 > $TOP_ROOT/build_ffmpeg.log 2>&1
	make install >> $TOP_ROOT/build_ffmpeg.log 2>&1
}

function build_sdl2.0()
{
	cd $TOP_ROOT/components
	if [ ! -d "SDL-2.0.9-12272" ];then
		cp -rf ../SDL-2.0.9-12272.tar.gz .
		tar -vxf SDL-2.0.9-12272.tar.gz
		rm SDL-2.0.9-12272.tar.gz
	else
		echo "SDL-2.0.9-12272 dir is existing"
	fi
	
	cd SDL-2.0.9-12272
	apt-get install libasound2-dev linux-sound-base alsa-base alsa-utils
	
	./configure --prefix=$PWD/tmp
    
    make -j8 > $TOP_ROOT/build_sdl2.0.log 2>&1
    make install >> $TOP_ROOT/build_sdl2.0.log 2>&1
}


if [ ! -f "$TOP_ROOT/components/lib/libav*.so" ];then
	build_ffmpeg
	cd $TOP_ROOT/components/ffmpeg-4.0.2/tmp/lib
	mkdir -p $TOP_ROOT/components/lib
	cp -rfd *so* $TOP_ROOT/components/lib
	
	mkdir -p $TOP_ROOT/components/include/ffmpeg
	cd ..
	cp -rf include $TOP_ROOT/components/include/ffmpeg
else
	exit 0
fi

if [ ! -f "$TOP_ROOT/components/lib/libSDL2.so" ];then
	build_sdl2.0
	cd $TOP_ROOT/components/SDL-2.0.9-12272/tmp/lib
	mkdir -p $TOP_ROOT/components/lib
	cp -rfd *so* $TOP_ROOT/components/lib
	
	mkdir -p $TOP_ROOT/components/include/sdl2.0
	cd ..
	cp -rf include $TOP_ROOT/components/include/sdl2.0
else
	exit 0
fi


echo "The ffmpeg and sdl lib is ok. Now you can build your app!" 
echo ""

