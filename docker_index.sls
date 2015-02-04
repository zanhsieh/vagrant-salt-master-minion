docker_index_image:
  docker.pulled:
    - name: index.docker.io/ekristen/docker-index:dev
    - force: True
    - order: 100

docker_index_stop_if_old:
  cmd.run:
    - name: docker stop docker_index
    - unless: docker inspect --format "\{\{ .Image \}\}" docker_index | grep $(docker images | grep "index.docker.io/ekristen/docker-index:dev" | awk '{ print $3 }')
    - require:
      - docker: docker_index_image
    - order: 111

docker_index_remove_if_old:
  cmd.run:
    - name: docker rm docker_index
    - unless: docker inspect --format "\{\{ .Image \}\}" docker_index | grep $(docker images | grep "index.docker.io/ekristen/docker-index:dev" | awk '{ print $3 }')
    - require:
      - cmd: docker_index_stop_if_old
    - order: 112

docker_index_container:
  docker.installed:
    - name: docker_index
    - image: index.docker.io/ekristen/docker-index:dev
    - environment:
      - "REDIS_HOST": "192.168.1.100"
      - "REDIS_PORT": "6379"
      - "PORT": "5100"
    - ports:
      - "5100/tcp"
    - require:
      - docker: docker_index_image
    - order: 120

docker_index_running:
  docker.running:
    - container: docker_index
    - port_bindings:
        "5001/tcp":
            HostIp: "0.0.0.0"
            HostPort: "5100"
    - require:
      - docker: docker_index_container
    - order: 121

