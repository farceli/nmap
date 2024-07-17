# Dockerfile
FROM ubuntu:20.04

# Set non-interactive mode for tzdata
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    autoconf \
    automake \
    libtool \
    gettext \
    libpcre3-dev \
    libssl-dev \
    libssh2-1-dev \
    libpcap-dev \
    libsqlite3-dev \
    zlib1g-dev \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    git \
    wget \
    tzdata

# Set up cross-compile environment
ENV CROSS_COMPILE=aarch64-linux-gnu-

WORKDIR /nmap

# Clone Nmap source code
RUN git clone https://github.com/nmap/nmap.git .

# Generate configure script
RUN autoreconf -fi

# Configure and build
RUN ./configure --host=aarch64-linux-gnu --target=aarch64-linux-gnu
RUN make

# Create output directory
RUN mkdir -p /nmap/output && chmod -R 777 /nmap/output

# Install Nmap
RUN make install DESTDIR=/nmap/output

CMD ["nmap", "--version"]
