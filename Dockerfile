FROM ubuntu:14.04

MAINTAINER Drew Heavner <veedubusc@gmail.com>

# Install java8
RUN apt-get install -y software-properties-common && add-apt-repository -y ppa:webupd8team/java && apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq libstdc++6:i386 zlib1g:i386 libncurses5:i386 --no-install-recommends && \
    apt-get clean

# Download and untar SDK
RUN cd /opt && wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r24.3.4-linux.tgz && tar xzf android-sdk.tgz && rm -f android-sdk.tgz && chown -R root.root android-sdk-linux

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install Android SDK components
COPY tools /opt/tools
RUN chown root:root /opt/tools && chmod 777 /opt/tools && chmod 777 /opt/tools/android-accept-licenses.sh && chmod 777 /opt/tools/setup-ssh.sh
ENV PATH ${PATH}:/opt/tools
RUN echo y | android update sdk --no-ui --force --all --filter tools,platform-tools,build-tools-23.0.1,android-23,extra-google-m2repository,extra-google-google_play_services,extra-android-support,extra-android-m2repository

# Git to pull external repositories of Android app projects
RUN apt-get install -y --no-install-recommends git openssh-client

# Mount the data volume and assume control of data and keys
VOLUME ~/data/.ssh:/root/.ssh
#RUN /opt/tools/setup-ssh.sh

# Cleaning
RUN apt-get clean

RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
