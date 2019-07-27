FROM omnetpp/omnetpp:u18.04-5.4.1

# Download and build the INET framework
WORKDIR /root/models
RUN wget https://github.com/inet-framework/inet/releases/download/v4.1.0/inet-4.1.0-src.tgz \
    && tar -xzf inet-4.1.0-src.tgz && rm inet-4.1.0-src.tgz && mv inet4 inet
WORKDIR /root/models/inet
RUN make makefiles && make -j$(grep -c proc /proc/cpuinfo)
WORKDIR /root/models