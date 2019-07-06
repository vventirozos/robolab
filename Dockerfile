FROM ubuntu:18.04
LABEL maintainer=v.ventirozos@gmail.com
ENV HOSTIP=192.168.1.7

# Register the ROCM repository, and install all packages needed
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get -y upgrade \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl libnuma-dev gnupg gnupg2 \
	&& curl -sL http://repo.radeon.com/rocm/apt/debian/rocm.gpg.key | apt-key add - \
	&& printf "deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main" | tee /etc/apt/sources.list.d/rocm.list \
	&& apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		sudo libelf1 rocm-dev build-essential git joe mc net-tools python3-opencv python3-setuptools \
		python3-pip python3-tk tk-dev libtk8.6 apt-transport-https \
		ca-certificates gnupg-agent software-properties-common \
		bpfcc-tools linux-headers-$(uname -r) gnupg2 lsb-release python3-argcomplete \
		systemtap systemtap-sdt-dev libreadline-dev zlib1g-dev flex bison screen \
		libxml2-dev libxslt-dev libssl-dev rocm-libs miopen-hip cxlactivitylogger wget python3-dev vim less
  
#### TF / KERAS gym

RUN pip3 install wheel
RUN pip3 install numpy --upgrade --ignore-installed
RUN pip3 install pytest --upgrade --ignore-installed 
RUN pip3 install jupyter ipython virtualenv tensorflow-rocm keras matplotlib gym
RUN jupyter notebook --generate-config \
	&& sed -i s/"#c.NotebookApp.ip = 'localhost'"/"c.NotebookApp.ip = '$HOSTIP'"/g /root/.jupyter/jupyter_notebook_config.py

#### ROS

RUN curl http://repo.ros2.org/repos.key | sudo apt-key add - \
	&& echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list
RUN apt-get update && apt-get install -y ros-dashing-desktop python3-colcon-common-extensions 
RUN echo "source /opt/ros/dashing/setup.bash" >> ~/.bashrc \
	&& echo "alias python='/usr/bin/python3'" >> ~/.bashrc

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
