#!/usr/bin/env bash

docker kill solr-container || true
docker rm solr-container || true
