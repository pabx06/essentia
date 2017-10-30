#!/bin/sh

echo "----------- tweaking /etc/apt/source.list ...."
sed 's|# deb|deb|g' -i /etc/apt/sources.list

# Update Ubuntu
echo "----------- apt-get update ...."
apt-get update
sed 's|# deb|deb|g' -i /etc/apt/sources.list

echo "----------- zone date ...."
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime


echo "----------- installing build dep [essentia] 1/2...."
#https://github.com/MTG/essentia-docker/blob/master/Dockerfile
apt-get install -y libyaml-0-2 libfftw3-3 libtag1v5 libsamplerate0 libavcodec-ffmpeg56 libavformat-ffmpeg56 libavutil-ffmpeg54 libavresample-ffmpeg2 python python-numpy libpython2.7 python-numpy python-yaml
echo "----------- done .... "

#swig
echo "----------- installing build dep [swig] 1/1...."
apt-get install -y autoconf automake bison libpcre++-dev
mkdir /swig && cd /swig && git clone --depth 1 https://github.com/swig/swig.git && cd /swig/swig && ./autogen.sh && ./configure --prefix=/usr/local \
	&& make && make install && ldconfig
echo "----------- done .... "


#gaia
echo "----------- installing build dep [gaia] 1/1...."
apt-get install -y build-essential libqt4-dev libyaml-dev python-dev pkg-config python-tk
mkdir /gaia && cd /gaia && git clone --depth 1 https://github.com/MTG/gaia.git
cd /gaia/gaia && ./waf configure --with-python-bindings --with-asserts --with-cyclops && ./waf && ./waf install


#essentia
echo "----------- installing build dep [essentia] 2/2...."
apt-get update
apt-get install -y build-essential libyaml-dev libfftw3-dev libavcodec-dev libavformat-dev libavutil-dev libavresample-dev python-dev libsamplerate0-dev libtag1-dev python-numpy-dev python-six git \
	&& mkdir /essentia && cd /essentia && git clone --depth 1 https://github.com/MTG/essentia.git \
	&& cd /essentia/essentia && ./waf configure --with-examples --with-python --with-vamp --with-gaia \
	&& ./waf && ./waf install && ldconfig
echo "----------- done .... "

