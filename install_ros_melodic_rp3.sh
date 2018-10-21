
#!/bin/bash
# Apache License 2.0
# Copyright (c) 2018, ROBOTIS CO., LTD.
echo "[Update the package lists and upgrade them]"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y screen
#if [ -z "$STY" ]; then exec screen -dm -S screenName /bin/bash "$0"; fi #start screen so that ssh connection can die

echo ""
echo "[Note] Target OS version  >>> Raspbian Stretch for the Raspberry Pi"
echo "[Note] Target ROS version >>> ROS Melodic Morenia"
echo "[Note] Catkin workspace   >>> $HOME/catkin_ws"
echo ""
echo "PRESS [ENTER] TO CONTINUE THE INSTALLATION"
echo "IF YOU WANT TO CANCEL, PRESS [CTRL] + [C]"
read

echo "[Set the target OS, ROS version and name of catkin workspace]"
name_os_version=${name_os_version:="bionic"}
name_ros_version=${name_ros_version:="melodic"}
name_catkin_workspace=${name_catkin_workspace:="catkin_ws"}
#dir="$( cd "$ dirname "$(BASH_SOURCE[0]}" )" >/dev/null && pwd )"


echo "[Install build environment, the chrony, ntpdate and set the ntpdate]"
sudo apt-get install -y chrony ntpdate build-essential dirmngr liburdfdom-dev liburdfdom-tools libbullet-dev
sudo ntpdate ntp.ubuntu.com
if [ -z "$STY" ]; then exec screen -dm -S screenName /bin/bash "$0"; fi #start screen so that ssh connection can die

echo "[Add the ROS repository]"
if [ ! -e /etc/apt/sources.list.d/ros-latest.list ]; then
  sudo sh -c "echo \"deb http://packages.ros.org/ros/ubuntu ${name_os_version} main\" > /etc/apt/sources.list.d/ros-latest.list"
fi

echo "[Download the ROS keys]"
roskey=`apt-key list | grep "ROS Builder"`
if [ -z "$roskey" ]; then
  sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
fi

echo "[Check the ROS keys]"
roskey=`apt-key list | grep "ROS Builder"`
if [ -n "$roskey" ]; then
  echo "[ROS key exists in the list]"
else
  echo "[Failed to receive the ROS key, aborts the installation]"
  exit 0
fi

mkdir -p ~/ros_catkin_ws
cd ~/ros_catkin_ws

echo "[Environment setup and getting rosinstall]"
sudo apt-get install -y python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential cmake

sudo rosdep init
rosdep update

bash ../ros_generate_melodic_rp3.sh $name_ros_version

sudo apt-get purge -y libtinyxml2-dev
sudo apt auto-remove -y

sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/$name_ros_version -j2
source /opt/ros/$name_ros_version/setup.sh

echo "[Initialize rosdep]"
sudo sh -c "rosdep init"
rosdep update

rosrun turtlebot3_bringup create_udev_rules

echo "[OpenCR setup]"
export OPENCR_PORT=/dev/ttyACM0
export OPENCR_MODEL=burger
rm -rf ./opencr_update.tar.bz2
wget https://github.com/ROBOTIS-GIT/OpenCR-Binaries/raw/master/turtlebot3/ROS1/latest/opencr_update.tar.bz2 && tar -xvf opencr_update.tar.bz2 && cd ./opencr_update && ./update.sh $OPENCR_PORT $OPENCR_MODEL.opencr && cd ..


echo "[Complete!!!]"
read
exit 0
