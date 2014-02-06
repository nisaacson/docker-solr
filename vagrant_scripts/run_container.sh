#!/usr/bin/env bash

IMAGE=solr
CONTAINER_NAME=solr-container

echo "-----> run solr-container"
ID=$(docker run -d -p 1111:22 -p 8983:8983 -name $CONTAINER_NAME $IMAGE)
echo "     container running with id $ID"
