FROM ubuntu:14.04.5
MAINTAINER Stephen Lawrence  <steve@stevesoffice.com>

# Update the APT cache
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list && \
   locale-gen en_US en_US.UTF-8

# Install and setup project dependencies
RUN apt-get update && \
  apt-get --no-install-recommends install -y  curl lsb-release supervisor wget openjdk-7-jre-headless && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/supervisor

RUN wget --progress=bar:force http://mirrored-packages.s3-website-us-west-1.amazonaws.com/packages/solr-4.2.0.tgz && \
  tar --extract --file solr-4.2.0.tgz -C /opt && \
  mv /opt/solr-4.2.0 /opt/solr

# Include basic config
# Can be override with volume -v flag
# EX: docker run -v /tmp/solr:/var/lib/solr/solr -p 1111:22 -p 8983:8983 -name solr-container nisaacson/solr
COPY ./solr_data /var/lib/solr/solr

# Use supervisor to keep both ssh server and solr java process running
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose Solr port
EXPOSE 8983

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
