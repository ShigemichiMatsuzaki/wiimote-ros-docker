FROM ros:noetic-ros-core
ARG BLUEZ_VERSION=5.54
ENV DEBIAN_FRONTEND noninteractive

#
# Bluez
# 
RUN apt-get update && apt-get install -y \
  git wget build-essential net-tools libudev-dev pkg-config \
  libusb-dev libdbus-1-dev libglib2.0-dev libudev-dev libical-dev libreadline-dev bluez bluetooth\
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

#
# Cwiid 
#
RUN apt-get update && apt-get install -y \
  libgtk2.0-dev gtk2.0 gawk bison flex \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y libbluetooth-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN cd /root/ && git clone https://github.com/azzra/python3-wiimote && cd python3-wiimote/ \
  && aclocal && autoconf \
  && ./configure \
  && make \
  && make install

#
# ROS
#
RUN apt-get update && apt-get install -y \
  python3-catkin-tools python3-osrf-pycommon python3-rosdep \
  python-is-python3 \
  ros-noetic-diagnostic-updater ros-noetic-roslint ros-noetic-joy \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
ENV CMAKE_PREFIX_PATH $CMAKE_PREFIX_PATH:/opt/ros/noetic

# Initialize the ROS environment
RUN rosdep init && rosdep update 

COPY ./docker_entrypoint.sh /docker_entrypoint.sh
RUN chmod +x /docker_entrypoint.sh
ENTRYPOINT ["/docker_entrypoint.sh"]
