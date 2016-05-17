## The default CentOS image has been used.
FROM centos:latest
MAINTAINER Pedro Cesar Azevedo <pedro.azevedo@concretesolutions.com.br>

## Install basic tools 
RUN yum install git lftp xorg-x11-fonts-Type1 xorg-x11-fonts-75dpi libpng libjpeg-turbo openssl libX11 libXext	libXrender -y

## Download and install wikitools
RUN curl -O http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-centos7-amd64.rpm
RUN rpm -Uvh wkhtmltox-0.12.2.1_linux-centos7-amd64.rpm

## Install repository, Node.JS and other tools.
RUN curl --silent --location https://rpm.nodesource.com/setup_5.x | bash -
RUN yum install nodejs bzip2 gcc gcc-c++ make freetype-devel fontconfig-devel -y

## Install the Sails framework globally
RUN npm install -g sails

## Install the PM2 process manager globally
RUN npm install pm2 -g

## The 1337 is the default port for this service
EXPOSE 1337

## Add a limited user and give him permission on the entrypoint dir
RUN mkdir -p /app/node-sails
RUN /usr/sbin/groupadd node -g 1000
RUN /usr/sbin/useradd -m node -g 1000 -u 1000 -d /app/
RUN chown -R 1000:1000 /app

## The /entrypoint volume must be mounted with the root of the
## node.js application
VOLUME /app

## Change the user to node and the dir to the Youse directory,
## which is where the process must to be started
USER node
WORKDIR /app/node-sails

## Start the main app using PM2
CMD pm2 start app.js --no-daemon
