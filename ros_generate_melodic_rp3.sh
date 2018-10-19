#/bin/bash
name_ros_version=${name_ros_version:="$1"}


rosinstall_generator actionlib actionlib_msgs angles bond bond_core bondcpp bondpy camera_calibration_parsers camera_info_manager catkin class_loader \
cmake_modules collada_parser collada_urdf common_msgs compressed_image_transport console_bridge control_msgs cpp_common cv_bridge diagnostic_aggregator \
diagnostic_analysis diagnostic_common_diagnostics diagnostic_msgs diagnostic_updater diagnostics dynamic_reconfigure eigen_conversions \
eigen_stl_containers executive_smach filters gencpp geneus genlisp genmsg gennodejs genpy geometric_shapes geometry geometry2 geometry_msgs \
hls_lfcd_lds_driver interactive_markers image_transport joint_state_publisher kdl_conversions kdl_parser message_filters message_generation message_runtime \
mk nav_msgs nodelet nodelet_core nodelet_topic_tools pluginlib python_qt_binding random_numbers resource_retriever robot \
robot_state_publisher ros ros_base ros_comm ros_core rosbag rosbag_migration_rule rosbag_storage rosbash rosboost_cfg rosbuild \
rosclean rosconsole rosconsole_bridge roscpp roscpp_core roscpp_serialization roscpp_traits roscreate rosgraph rosgraph_msgs roslang \
roslaunch roslib roslint roslisp roslz4 rosmake rosmaster rosmsg rosnode rosout rospack rosparam rospy rosserial_msgs rosserial_python \
rosservice rostest rostime rostopic rosunit roswtf self_test sensor_msgs shape_msgs smach smach_msgs smach_ros smclib std_msgs std_srvs \
stereo_msgs tf tf_conversions tf2 tf2_kdl tf2_msgs tf2_py tf2_ros topic_tools trajectory_msgs turtlebot3_msgs \
urdf urdf_parser_plugin visualization_msgs xacro xmlrpcpp --rosdistro $name_ros_version --deps --wet-only --tar > $name_ros_version-core-wet.rosinstall

#wstool init src $name_ros_version-core-wet.rosinstall
cd ./src
git clone https://github.com/ROBOTIS-GIT/turtlebot3.git
git clone https://github.com/UbiquityRobotics/raspicam_node.git

cd ../
mkdir ./external_src
cd ./external_src
#wget http://sourceforge.net/projects/assimp/files/assimp-3.1/assimp-3.1.1_no_test_models.zip/download -O assimp-3.1.1_no_test_models.zip
#unzip assimp-3.1.1_no_test_models.zip
cd assimp-3.1.1
#cmake .
#make
sudo make install

cd ../
git clone https://github.com/OctoMap/octomap.git
cd octomap
mkdir build
cd build
#cmake ..
#make
sudo make install

cd ../..

OUTPUT="$(ls -l)"
echo "${OUTPUT}"

git clone https://github.com/orocos/orocos_kinematics_dynamics.git
cd oroc*
cd orocus_kdl
mkdir build
cd build
cmake ..
make
sudo make install
cd ../..

cd ./python_orocus_kdl
mkdir build
cd build
cmake ..
make
sudo make install
cd ../../..

https://github.com/leethomason/tinyxml2.git
cd ./tinyxml2
mkdir build
cd build
cmake ..
make
sudo make install
cd ../

rosdep install -y --from-paths src --ignore-src --rosdistro $name_ros_version -r --os=debian:stretch
rosdep install -y --from-paths src --ignore-src --rosdistro $name_ros_version -r --os=debian:stretch


#octomap
#opencv3
#orocos_kdl
#python_orocos_kdl
