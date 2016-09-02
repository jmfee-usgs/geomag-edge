# dockerfile to build basic edge/cwb image

FROM debian:jessie

MAINTAINER Jeremy Fee <jmfee@usgs.gov>
LABEL usgs.geomag-edge.version=0.1.0


# update os
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        net-tools \
        openjdk-7-jdk \
        sudo && \
    apt-get clean


# set up vdl account
RUN /bin/bash -c " \
    ln -s /usr /usr/java && \
    mkdir /TEMP && \
    cd /TEMP && \
    curl -O ftp://hazards.cr.usgs.gov/CWBQuery/EdgeCWBRelease.tar.gz && \
    zcat EdgeCWBRelease.tar.gz | tar xf - && \
    tar xf scripts_release.tar && \
    cd scripts/INSTALL && \
    ./addAccount vdl && \
    sudo -u vdl cp /TEMP/EdgeCWBRelease.tar.gz ~vdl && \
    cd ~vdl && \
    sudo -u vdl /TEMP/scripts/installCWBRelease.bash && \
    rm -rf /TEMP && \
    echo 'vdl - memlock 1024' >> /etc/security/limits.conf && \
    echo 'vdl - stack 81920' >> /etc/security/limits.conf && \
    echo 'vdl - nproc 20480' >> /etc/security/limits.conf && \
    echo 'vdl - nofile 8192' >> /etc/security/limits.conf && \
    mkdir /data && \
    chown vdl:vdl /data /home/vdl \
    "

# add docker entrypoint and configuration scripts
COPY * /home/vdl/


USER vdl
EXPOSE 2060 7981
WORKDIR /home/vdl
CMD [ "./docker-entrypoint.sh" ]
