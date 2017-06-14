FROM ubuntu:16.04

RUN apt-get update > /dev/null 2>&1 && \
    apt-get install -yqq lsb-release apt-utils wget curl vim r10k > /dev/null 2>&1 && \
    wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb -O /tmp/puppetlabs-release-pc1-xenial.deb && \
    dpkg -i /tmp/puppetlabs-release-pc1-xenial.deb && \
    apt-get update > /dev/null 2>&1 && \
    apt-get install -yqq puppet-agent > /dev/null 2>&1

RUN echo "#!/bin/bash" > /config.sh && \
    echo "cd /etc/puppetlabs/code/environments/production" >> /config.sh && \
    echo "r10k puppetfile install -v" >> /config.sh && \
    chmod 755 /config.sh

RUN echo "#!/bin/bash" > /test.sh && \
    echo "/opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp" >> /test.sh && \
    chmod 755 /test.sh

COPY Puppetfile /etc/puppetlabs/code/environments/production/Puppetfile

RUN bash /config.sh

ARG APPTIER
ARG PROJECT
ARG APPLICATION
ARG ROLE

RUN echo "---" > /opt/puppetlabs/facter/facts.d/provision.yaml && \
    echo "apptier: $APPTIER" >> /opt/puppetlabs/facter/facts.d/provision.yaml && \
    echo "project: $PROJECT" >> /opt/puppetlabs/facter/facts.d/provision.yaml && \
    echo "appname: $APPLICATION" >> /opt/puppetlabs/facter/facts.d/provision.yaml && \
    echo "environment: production" >> /opt/puppetlabs/facter/facts.d/provision.yaml && \
    echo "role: $ROLE" >> /opt/puppetlabs/facter/facts.d/provision.yaml

COPY ./ /etc/puppetlabs/code/environments/production/

RUN cp /etc/puppetlabs/code/environments/production/hiera.yaml /etc/puppetlabs/puppet/hiera.yaml
