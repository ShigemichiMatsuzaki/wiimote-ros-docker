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


#RUN cd /root/ && git clone https://github.com/abstrakraft/cwiid && cd cwiid/ \
#  && sed -i -e 's/^\(LDLIBS.*\)/\1 -lbluetooth/g' wmdemo/Makefile.in \
#  && aclocal && autoconf \
#  && ./configure \
#  && make \
#  && make install

# Install ROS melodic
#RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
#RUN apt-key adv --keyserver 'hkp://ha.pool.sks-keyservers.net:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
#RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

#
# ROS
#
RUN apt-get update && apt-get install -y \
  python3-catkin-tools python3-osrf-pycommon python3-rosdep \
  python-is-python3 \
  ros-noetic-diagnostic-updater ros-noetic-roslint \
#  python3-pip libcwiid1 libcwiid-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Initialize the ROS environment
RUN rosdep init && rosdep update 

#RUN cd /tmp && wget http://www.kernel.org/pub/linux/bluetooth/bluez-${BLUEZ_VERSION}.tar.xz \
#  && tar xvf bluez-${BLUEZ_VERSION}.tar.xz \
#  && cd bluez-${BLUEZ_VERSION} && ./configure --enable-library \
#  && make \
#  && make install
#RUN systemctl status bluetooth

COPY ./docker_entrypoint.sh /docker_entrypoint.sh
RUN chmod +x /docker_entrypoint.sh
ENTRYPOINT ["/docker_entrypoint.sh"]
