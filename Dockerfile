FROM centos:centos6
# replace this with your application's default port

# Enable EPEL for Node.js
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum -y install wget
RUN yum -y install tar
RUN yum -y groupinstall "Development Tools"

# Install Node.js and npm
RUN mkdir /src
RUN mkdir /src/node
RUN cd /src/node && wget https://nodejs.org/dist/v0.12.7/node-v0.12.7.tar.gz
RUN cd /src/node && tar -zxvf node-v0.12.7.tar.gz

RUN cd /src/node/node-v0.12.7 && ./configure
RUN cd /src/node/node-v0.12.7 && make
RUN cd /src/node/node-v0.12.7 && make install 


# RUN yum install -y npm
RUN	yum install -y git
RUN	yum install -y openssh-clients

# Make ssh dir
RUN mkdir /root/.ssh/

# Copy over private key, and set permissions
COPY ./deploy_key /root/.ssh/id_rsa
COPY ./deploy.sh /
RUN chmod +x /deploy.sh

# Create known_hosts
RUN touch /root/.ssh/known_hosts
# Add bitbuckets key
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

EXPOSE  3000
RUN /deploy.sh

WORKDIR /app

ENV NODE_ENV beta

ENTRYPOINT ["node"]
CMD ["./bin/production.js"]