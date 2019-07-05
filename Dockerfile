FROM ubuntu:18.04
LABEL maintainer=v.ventirozos@gmail.com


# Register the ROCM package repository, and install rocm-dev package
RUN apt-get update && apt-get -y upgrade && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl libnuma-dev gnupg gnupg2 \
	&& curl -sL http://repo.radeon.com/rocm/apt/debian/rocm.gpg.key | apt-key add - \
	&& printf "deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main" | tee /etc/apt/sources.list.d/rocm.list \
	&& apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	sudo libelf1 rocm-dev build-essential git joe mc net-tools python3-opencv python3-setuptools \
	python3-pip python3-tk tk-dev libtk8.6 apt-transport-https \
	ca-certificates gnupg-agent software-properties-common \
	bpfcc-tools linux-headers-$(uname -r) gnupg2 lsb-release python3-argcomplete \
	systemtap systemtap-sdt-dev libreadline-dev zlib1g-dev flex bison screen \
	libxml2-dev libxslt-dev libssl-dev rocm-libs miopen-hip cxlactivitylogger wget python3-dev vim less
  
#  && apt-get clean && rm -rf /var/lib/apt/lists/*

#### TF / KERAS

RUN pip3 install wheel
RUN pip3 install numpy --upgrade --ignore-installed
RUN pip3 install pytest --upgrade --ignore-installed 
RUN pip3 install jupyter ipython virtualenv tensorflow-rocm keras matplotlib gym

#### ROS

RUN curl http://repo.ros2.org/repos.key | sudo apt-key add -
RUN echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list
RUN apt-get update && apt-get install -y ros-dashing-desktop python3-colcon-common-extensions \
&& echo "source /opt/ros/dashing/setup.bash" >> ~/.bashrc


