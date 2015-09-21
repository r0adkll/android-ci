FROM java:8

MAINTAINER Drew Heavner <veedubusc@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq libstdc++6:i386 zlib1g:i386 libncurses5:i386 --no-install-recommends && \
    apt-get clean

# Download and untar SDK
ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.1.2-linux.tgz
RUN curl -L "${ANDROID_SDK_URL}" | tar --no-same-owner -xz -C /usr/local
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

# Install Android SDK components
# Potentially move this to the gitlab ci script

ONBUILD RUN echo y | android update sdk --no-ui --force --all --filter tools,platform-tools,build-tools-23.0.1,android-23,extra-google-m2repository,extra-google-google_play_services,extra-android-support,extra-android-m2repository

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS -Xms256m -Xmx1024m
