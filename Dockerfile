# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM centos:centos7
MAINTAINER Green Gerong <https://github.com/greengerong>

RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8
RUN yum update -y 
# Install a basic SSH server
RUN yum install -y openssh openssh-server openssh-clients
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Generate hostkeys for sshd start
RUN sshd-keygen

# Install JDK 8, maven 3
RUN yum install -y java-1.8.0-openjdk maven git perl

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Add user jenkins to the image
RUN useradd jenkins
# # Set password for the jenkins user (you may want to alter this).
# RUN echo "jenkins:jenkins" | chpasswd
# RUN echo "root:jenkins" | chpasswd


# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]