FROM ubuntu:16.04
LABEL maintainer="Jonathan Hanson (jonathan@jonathan-hanson.org)"

ENV znc_version=1.6.5
ENV znc_exec_user=znc-admin
ENV znc_config_root=/etc/znc
ARG znc_port=6666

RUN apt-get update && apt-get install -y \
      build-essential \
      curl \
      libicu-dev \
      libperl-dev \
      libssl-dev \
      pkg-config \
      swig3.0 \
    && rm -rf /var/lib/apt/lists/*

# Fetch build sources
WORKDIR /tmp
RUN curl -LO http://znc.in/releases/archive/znc-$znc_version.tar.gz
RUN curl -LO https://raw.githubusercontent.com/jpnurmi/znc-clientbuffer/znc-1.6.0/clientbuffer.cpp

# Unpack the source into the source directory
RUN rm -rf /usr/local/src/znc-$znc_version \
    && tar -xvf /tmp/znc-$znc_version.tar.gz -C /usr/local/src \
    && cp /tmp/clientbuffer.cpp /usr/local/src/znc-$znc_version/modules/

# Make and install ZNC
WORKDIR /usr/local/src/znc-$znc_version
RUN ./configure \
    && make \
    && make install

# Set up the ZNC user and group
RUN groupadd -r $znc_exec_user \
    && useradd --no-log-init -r -g $znc_exec_user $znc_exec_user

# Set up the ZNC configuration directory
VOLUME $znc_config_root

# Set up the ZNC self signed certificate
RUN /usr/local/bin/znc --datadir=$znc_config_root --makepem

# set up the service to run when the container starts
USER $znc_exec_user
EXPOSE $znc_port
#CMD /usr/local/bin/znc --datadir=$znc_config_root --foreground --debug
CMD /usr/local/bin/znc --datadir=$znc_config_root --foreground
