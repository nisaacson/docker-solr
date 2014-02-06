Docker Solr
===========

Builds a docker image for `solr-4.2.0`

# Usage


```bash
# start a solo solr server
vagrant up alpha --provision
```

Open your browser to `http://localhost:8983/solr/`. You should see the Apache Solr admin page.


# Building

To build a docker image, use the included Vagrantfile to launch up a virtual machine with docker already installed. The Vagrantfile uses the [vagrant docker provisioner](http://docs.vagrantup.com/v2/provisioning/docker.html) to install docker

**Requirements**

* [Vagrant](http://www.vagrantup.com/)

To launch the vagrant virtual machine

```bash
cd /path/to/this/repo
vagrant up alpha
```

Once the virtual machine is running you can test out the `Dockerfile` via

```bash
# log into the virtual machine
vagrant ssh
# go to the mounted shared folder
cd /vagrant/app

# build a docker image from the Dockerfile
docker build -t solr .

# ensure that the image exists, you should see the `solr` image in the list output
docker images

# run the container, mapping ports on the host virtual machine to the same ports inside the container
ID=$(docker run -d -p 1111:22 -p 8983:8983 solr)

# wait a few seconds and then check the logs on the container, you should see the output from solr starting up.
docker logs $ID

# connect to the solr service running in the container via solr http interface
curl "http://localhost:8983"

# You can connect to the running container via the mapped ssh port
# password: root
ssh -p 2222 root@localhost
```

# Notes

To use a custom solr data configuration and data folder, use the [volumes](http://docs.docker.io/en/latest/use/working_with_volumes/) feature of docker to mount the solr data folder inside the container at `/var/lib/solr/solr`.

The initial usage example of `vagrant up alpha --provision` actually uses the volumes feature to mount the custom config located at `./app/solr_data` in the docker solr container.

```bash
# volumes
HOST_SOLR_VOLUME=/home/vagrant/app/solr_data # used by default vagrant docker provisioner
CONTAINER_SOLR_VOLUME=/var/lib/solr/solr # Hard coded in ./app/supervisord.conf

# ports
HOST_SSH_PORT=1111
CONTAINER_SSH_PORT=22

HOST_SOLR_PORT=1111
CONTAINER_SOLR_PORT=22



docker run \
  -d # detached
  -name solr-container
  -p $HOST_SSH_PORT:$CONTAINER_SSH_PORT    \
  -p $HOST_SOLR_PORT:$CONTAINER_SOLR_PORT  \
  -v $HOST_SOLR_VOLUME:$CONTAINER_SOLR_VOLUME
  solr # image name
```

