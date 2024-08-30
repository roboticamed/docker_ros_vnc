ARG IMAGE="osrf/ros:noetic-desktop-full"
ARG OS="linux"

FROM ${IMAGE}

ARG WS
ENV DEBIAN_FRONTEND=noninteractive
ENV RESOLUTION=1920x1080
ENV ROS_DISTRO=noetic
ENV USER=root
ENV WS=${WS}
WORKDIR ${WS}

RUN apt update && apt install -y \
    python3-catkin-tools \
    python3-rosinstall \
    wget \
    curl \
    git \
    nano \
    graphviz \
    iputils-ping \
    net-tools

COPY /install_ros_noetic.sh ${WS}/install_ros_noetic.sh
RUN chmod +x ${WS}/install_ros_noetic.sh
RUN ${WS}/install_ros_noetic.sh ${ROS_DISTRO} ${WS}

RUN mkdir -p ${WS}/src && \
    cd ${WS}/src && \
    git clone https://github.com/GGomezMorales/waver.git && \
    cd waver && \
    mv * ${WS}/src/ && \
    cd ${WS}/src && \
    rm -rf waver && \
    cd ${WS} && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
RUN echo "source ${WS}/devel/setup.bash" >> ~/.bashrc
RUN echo "alias sros='source /opt/ros/${ROS_DISTRO}/setup.bash ; catkin build ; source ${WS}/devel/setup.bash'" >> ~/.bashrc
