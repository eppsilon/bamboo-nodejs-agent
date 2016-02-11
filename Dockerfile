FROM atlassian/bamboo-base-agent
MAINTAINER Brett Epps <brett.epps@software.dell.com>

# add source with graphicsmagick
RUN apt-get update
RUN apt-get -y install software-properties-common
RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"

# update apt
RUN apt-get update

# install git
RUN apt-get -y install git

# install build tools for node-gyp
RUN apt-get -y install g++ libc-dev build-essential

# install graphicsmagick
RUN apt-get -y install graphicsmagick

# install ruby
RUN apt-get -y install ruby1.9.1

# install python
RUN apt-get -y install python2.7

# set python 2.7 as the default version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 2 && \
  update-alternatives --install /usr/bin/python python /usr/bin/python3.4 1

# install node from source
RUN \
  cd /opt && \
  wget http://nodejs.org/dist/v4.3.0/node-v4.3.0-linux-x64.tar.gz && \
  tar -xzf node-v4.3.0-linux-x64.tar.gz && \
  mv node-v4.3.0-linux-x64 node && \
  cd /usr/local/bin && \
  ln -s /opt/node/bin/* . && \
  rm -f /opt/node-v4.3.0-linux-x64.tar.gz

# configure/update npm
# NOTE: changing registry to HTTP avoids ECONNRESET errors?
#       https://github.com/npm/npm/issues/9418
RUN npm config set registry http://registry.npmjs.org/ && \
  npm config set prefix /usr/local && \
  npm install -g npm

# install common node packages
RUN npm install -g gulp bower coffeelint eslint

# install phantomjs
ADD phantomjs-2.1.1-linux-x86_64.tar.bz2 /opt/phantomjs
RUN mv /opt/phantomjs/phantomjs-2.1.1-linux-x86_64/* /opt/phantomjs && \
  rm -rf /opt/phantomjs/phantomjs-2.1.1-linux-x86_64 && \
  cd /usr/local/bin && \
  ln -s /opt/phantomjs/bin/phantomjs phantomjs

# install common ruby packages
RUN gem install sass scss_lint

# add agent properties
ADD bamboo-capabilities.properties /root/bamboo-agent-home/bin/bamboo-capabilities.properties
