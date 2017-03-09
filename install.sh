#!/bin/bash

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install git g++ python libusb-1.0-0-dev freeglut3-dev doxygen graphviz
sudo apt-get install build-essential cmake pkg-config
sudo apt-get install libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install libxvidcore-dev libx264-dev
sudo apt-get install libgtk2.0-dev
sudo apt-get install libatlas-base-dev gfortran
sudo apt-get install python2.7-dev python3-dev

LOC_DIR=$PWD

if [ ! -d $LOC_DIR/kinect/ ]; then
  mkdir kinect
fi
cd kinect

if [ ! -d $LOC_DIR/kinect/OpenNI/ ]; then  
	echo "Installing OpenNI"
	cd $LOC_DIR/kinect/
	git clone https://github.com/OpenNI/OpenNI.git -b unstable 
	sed -i 's/CFLAGS += -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp #-mcpu=cortex-a8/CFLAGS += -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard/g' $LOC_DIR/kinect/OpenNI/Platform/Linux/Build/Common/Platform.Arm
	sed -i 's/MAKE_ARGS += "'" -j"'" + calc_jobs_number()/MAKE_ARGS += "'" -j1"'"/g' $LOC_DIR/kinect/OpenNI/Platform/Linux/CreateRedist/Redist_OpenNi.py
	cd $LOC_DIR/kinect/OpenNI/Platform/Linux/CreateRedist/
	./RedistMaker.Arm
	cd $LOC_DIR/kinect/OpenNI/Platform/Linux/Redist/OpenNI-Bin-Dev-Linux-Arm-v1.5.8.5/
	sudo ./install.sh
else
	echo "OpenNI already installed"
fi

if [ ! -d $LOC_DIR/kinect/Sensor/ ]; then
        echo "Installing Sensor"
	cd $LOC_DIR/kinect/
        git clone https://github.com/PrimeSense/Sensor.git -b unstable
        sed -i 's/CFLAGS += -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp #-mcpu=cortex-a8/CFLAGS += -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard/g' $LOC_DIR/kinect/Sensor/Platform/Linux/Build/Common/Platform.Arm
        sed -i 's/make -j$(calc_jobs_number) -C ..\/Build/make -j1 -C ..\/Build/g' $LOC_DIR/kinect/Sensor/Platform/Linux/CreateRedist/RedistMaker
	cd $LOC_DIR/kinect/Sensor/Platform/Linux/CreateRedist/
	./RedistMaker Arm
	cd $LOC_DIR/kinect/Sensor/Platform/Linux/Redist/Sensor-Bin-Linux-Arm-v5.1.6.6/
	sudo ./install.sh
else
        echo "Sensor already installed"
fi



if [ ! -d $LOC_DIR/kinect/SensorKinect/ ]; then
        echo "Installing SensorKinect"
	cd $LOC_DIR/kinect/
	git clone git://github.com/ph4m/SensorKinect.git
	sed -i 's/CFLAGS += -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp #-mcpu=cortex-a8/CFLAGS += -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard/g' $LOC_DIR/kinect/SensorKinect/Platform/Linux/Build/Common/Platform.Arm
	sed -i 's/make -j$(calc_jobs_number) -C ..\/Build/make -j1 -C ..\/Build/g' $LOC_DIR/kinect/SensorKinect/Platform/Linux/CreateRedist/RedistMaker
	cd $LOC_DIR/kinect/SensorKinect/Platform/Linux/CreateRedist/
	./RedistMaker Arm
	cd $LOC_DIR/kinect/SensorKinect/Platform/Linux/Redist/Sensor-Bin-Linux-Arm-v5.1.2.1
	sudo ./install.sh
else
        echo "SensorKinect already installed"
fi

if [ ! -d $LOC_DIR/kinect/opencv-3.1.0/ ]; then
	echo "Installing OpenCV"
	cd $LOC_DIR/kinect/
	mkdir opencv
	cd opencv
	wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.1.0.zip
	wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.1.0.zip
	unzip opencv_contrib.zip
	unzip opencv.zip

	#opencv 3-1.0 install
	cd opencv-3.1.0/
	mkdir build
	cd build
	cmake -D CMAKE_BUILD_TYPE=RELEASE \
	    -D CMAKE_INSTALL_PREFIX=/usr/local \
	    -D WITH_OPENNI=ON \
	    -D OPENCV_EXTRA_MODULES_PATH=$LOC_DIR/kinect/opencv/opencv_contrib-3.1.0/modules \
	    -D BUILD_EXAMPLES=ON ..
	make
	sudo make install
	sudo ldconfig
else
	echo "OpenCV already installed"
fi
