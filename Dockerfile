FROM atlassian/bamboo-base-agent
MAINTAINER Brett Epps <brett.epps@software.dell.com>

# install make for node-gyp
RUN apt-get update && apt-get -y install build-essential

# install our dependencies and nodejs
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install git graphicsmagick

# Install Node
RUN \
  cd /opt && \
  wget http://nodejs.org/dist/v4.2.4/node-v4.2.4-linux-x64.tar.gz && \
  tar -xzf node-v4.2.4-linux-x64.tar.gz && \
  mv node-v4.2.4-linux-x64 node && \
  cd /usr/local/bin && \
  ln -s /opt/node/bin/* . && \
  rm -f /opt/node-v4.2.4-linux-x64.tar.gz

RUN npm config set prefix /usr/local && \
    npm install -g npm && \
    npm install -g gulp bower coffeelint eslint && \
    npm install -g phantomjs@1.9.19

ADD setup.sh /

RUN /setup.sh

ADD bamboo-capabilities.properties /root/bamboo-agent-home/bin/bamboo-capabilities.properties
