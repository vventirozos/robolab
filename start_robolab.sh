echo "to start jupyter: jupyter notebook --allow-root --port=8889"

docker run -i -t \
--network=host \
--device=/dev/kfd \
--device=/dev/dri \
--group-add video \
--cap-add=SYS_PTRACE \
--security-opt seccomp=unconfined \
--workdir=/root/robolab \
-v /data/Docker_share/robolab:/root/robolab evolmonkey/robolab:v1.0 /bin/bash
