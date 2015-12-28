FROM atlassian/bamboo-base-agent
MAINTAINER Brett Epps <brett.epps@software.dell.com>

# add source with graphicsmagick
RUN apt-get update
RUN apt-get -y install software-properties-common
RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"

# update apt
RUN apt-get update

# install build tools for node-gyp
RUN apt-get -y install g++ libc-dev build-essential

# install graphicsmagick
RUN apt-get -y install graphicsmagick

# install ruby
RUN apt-get -y install ruby1.9.1

# install python
RUN apt-get -y install python2.7

# install node from source
RUN \
  cd /opt && \
  wget http://nodejs.org/dist/v4.2.4/node-v4.2.4-linux-x64.tar.gz && \
  tar -xzf node-v4.2.4-linux-x64.tar.gz && \
  mv node-v4.2.4-linux-x64 node && \
  cd /usr/local/bin && \
  ln -s /opt/node/bin/* . && \
  rm -f /opt/node-v4.2.4-linux-x64.tar.gz

# configure/update npm
RUN npm config set prefix /usr/local && npm install -g npm

# install common node packages
RUN npm install -g gulp bower coffeelint eslint

# install phantomjs
RUN npm install -g phantomjs@1.9.19

# install common ruby packages
RUN gem install sass scss_lint

# add agent properties
ADD bamboo-capabilities.properties /root/bamboo-agent-home/bin/bamboo-capabilities.properties
