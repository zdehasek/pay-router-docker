FROM centos:centos7
# replace this with your application's default port

# Enable EPEL for Node.js
RUN yum -y install epel-release.noarch

# Install build tools and utils
RUN yum -y install tar wget git openssh-clients gcc-c++ make curl

# Install Node.js and npm
RUN mkdir -p /src/node
RUN cd /src/node && wget https://nodejs.org/dist/v4.1.2/node-v4.1.2.tar.gz
RUN cd /src/node && tar -zxvf node-v4.1.2.tar.gz

# Build node
RUN cd /src/node/node-v4.1.2 && ./configure && make && make install

# Make ssh dir
RUN mkdir /root/.ssh/

# Create known_hosts
RUN touch /root/.ssh/known_hosts
# Add githubs key
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN mv /usr/share/zoneinfo/Europe/Prague /etc/localtime


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
