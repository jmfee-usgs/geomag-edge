# dockerfile to build basic edge/cwb image

FROM usgs/java:8

LABEL maintainer="Jeremy Fee <jmfee@usgs.gov>"

# set up vdl account
RUN yum install -y net-tools sudo \
    && mkdir /TEMP \
    && cd /TEMP \
    && curl -O ftp://hazards.cr.usgs.gov/CWBQuery/EdgeCWBRelease.tar.gz \
    && zcat EdgeCWBRelease.tar.gz | tar xf - \
    && tar xf scripts_release.tar \
    && cd scripts/INSTALL \
    && ./addAccount vdl \
    && sudo -u vdl cp /TEMP/EdgeCWBRelease.tar.gz ~vdl \
    && cd ~vdl \
    && sudo -u vdl /TEMP/scripts/installCWBRelease.bash \
    && cp ~vdl/NoDB/DB/*.txt ~vdl/DB/. \
    && rm -rf /TEMP \
    && echo 'vdl - memlock 1024' >> /etc/security/limits.conf \
    && echo 'vdl - stack 81920' >> /etc/security/limits.conf \
    && echo 'vdl - nproc 20480' >> /etc/security/limits.conf \
    && echo 'vdl - nofile 8192' >> /etc/security/limits.conf \
    && mkdir /data \
    && chown vdl:vdl /data /home/vdl

# add docker entrypoint and configuration scripts
COPY docker-configure.sh docker-entrypoint.sh /home/vdl/


USER vdl
EXPOSE 2060 2061 7974 7981
WORKDIR /home/vdl
CMD [ "./docker-entrypoint.sh" ]
