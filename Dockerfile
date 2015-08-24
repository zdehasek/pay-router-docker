FROM centos:centos6
# replace this with your application's default port

# Enable EPEL for Node.js
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

# Install build tools and utils
RUN yum -y install wget
RUN yum -y install tar
RUN yum -y groupinstall "Development Tools"

# Install Node.js and npm
RUN mkdir /src
RUN mkdir /src/node
RUN cd /src/node && wget https://nodejs.org/dist/v0.12.7/node-v0.12.7.tar.gz
RUN cd /src/node && tar -zxvf node-v0.12.7.tar.gz

# Build node
RUN cd /src/node/node-v0.12.7 && ./configure
RUN cd /src/node/node-v0.12.7 && make
RUN cd /src/node/node-v0.12.7 && make install 

# Install git and ssh
RUN	yum install -y git
RUN	yum install -y openssh-clients

# Make ssh dir
RUN mkdir /root/.ssh/

# Create known_hosts
RUN touch /root/.ssh/known_hosts
# Add githubs key
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# --------- Private part ---------

# Copy over private key, and set permissions
COPY ./deploy_key /root/.ssh/id_rsa

# Prepare and run deploy script
COPY ./deploy.sh /
RUN chmod +x /deploy.sh
RUN /deploy.sh

# Prepare run script
COPY ./run.sh /
RUN chmod +x /run.sh

EXPOSE  3000
WORKDIR /app
ENV NODE_ENV beta

CMD ["/run.sh"]