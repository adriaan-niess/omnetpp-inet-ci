FROM ubuntu:18.04

# Install packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -qq -y install build-essential gcc g++ bison flex perl-base \
    python python3 tcl-dev libxml2-dev libxml2-utils zlib1g-dev default-jre wget cmake python3

# Download and build Omnet++
WORKDIR /root
RUN wget https://github.com/omnetpp/omnetpp/releases/download/omnetpp-5.5.1/omnetpp-5.5.1-src-linux.tgz \
    && tar -xzf omnetpp-5.5.1-src-linux.tgz \
    && rm omnetpp-5.5.1-src-linux.tgz \
    && mv omnetpp-5.5.1 /root/omnetpp
WORKDIR /root/omnetpp
ENV PATH=$PATH:/root/omnetpp/bin
RUN ./configure WITH_TKENV=no WITH_QTENV=no WITH_OSG=no WITH_OSGEARTH=no WITH_PARSIM=no \
    && make -j$(grep -c proc /proc/cpuinfo)

# Download and build the INET framework
RUN mkdir -p /root/models
WORKDIR /root/models
RUN wget https://github.com/inet-framework/inet/releases/download/v4.2.0/inet-4.2.0-src.tgz \
    && tar -xzf inet-4.2.0-src.tgz && rm inet-4.2.0-src.tgz && mv inet4 inet
WORKDIR /root/models/inet
RUN make makefiles && make -j$(grep -c proc /proc/cpuinfo) && make MODE=debug -j$(grep -c proc /proc/cpuinfo)
WORKDIR /root/models

# Download and build Cppcheck
WORKDIR /root
RUN wget https://github.com/danmar/cppcheck/archive/1.89.tar.gz \
    && tar -xzf 1.89.tar.gz && rm 1.89.tar.gz && mv cppcheck-1.89 cppcheck
WORKDIR /root/cppcheck
RUN cmake . && make -j$(grep -c proc /proc/cpuinfo)