Docker Solr
===========

Builds a docker image for `solr-4.2.0`

# Usage
Open your browser to `http://localhost:8983/solr/`. You should see the Apache Solr admin page.


# Building

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

# Notes

To use a custom solr data configuration and data folder, use the [volumes](http://docs.docker.io/en/latest/use/working_with_volumes/) feature of docker to mount the solr data folder inside the container at `/var/lib/solr/solr`.

bash
```
# volumes
CONTAINER_SOLR_VOLUME=/var/lib/solr/solr # Hard coded in ./app/supervisord.conf

# ports
HOST_SOLR_PORT=8983
CONTAINER_SOLR_PORT=8983

docker run \
  -d # detached
  -name solr-container
  -p $HOST_SOLR_PORT:$CONTAINER_SOLR_PORT  \
  -v $HOST_SOLR_VOLUME:$CONTAINER_SOLR_VOLUME
  solr # image name
```