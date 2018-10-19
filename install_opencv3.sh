#/bin/bash

sudo apt-get install -y build-essential cmake pkg-config git 
sudo apt-get install -y libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev libavcodec-dev 
sudo apt-get install -y libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev 
sudo apt-get install -y libgtk2.0-dev libgtk-3-dev libatlas-base-dev gfortran python2.7-dev python3-dev
cd ~
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git

#Get PIP
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo python3 get-pip.py
sudo pip install virtualenv virtualenvwrapper
sudo rm -rf ~/.cache/pip

# virtualenv and virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
echo -e "\n# virtualenv and virtualenvwrapper" >> ~/.profile
echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.profile
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.profile
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.profile

source ~/.profile

#virtual python env
mkvirtualenv cv -p python3
source ~/.profile
workon cv
sudo pip install numpy
cd ~/opencv*
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv/modules \
    -D BUILD_EXAMPLES=ON ..


make -j2
sudo make install
sudo ldconfig

