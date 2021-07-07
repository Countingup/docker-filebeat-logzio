FROM docker.elastic.co/beats/filebeat-oss:6.8.16

LABEL org.opencontainers.image.source="https://github.com/Countingup/docker-filebeat-logzio"

# Add custom filebeat config
COPY filebeat.yml /usr/share/filebeat/filebeat.yml

USER root

# Update base image packages, as this was missed in Elastic's CI
# See https://github.com/elastic/beats/issues/25886
RUN yum -y update && \
    yum clean all && \
    rm -rf /var/cache/yum

# Set permissions on filebeat config, see https://www.elastic.co/guide/en/beats/libbeat/6.8/config-file-permissions.html
# Get Logz.io CA cert, updated for CA change, see https://docs.logz.io/technical-notes/chain-of-trust/#replace-the-cert-file and set perms
RUN chgrp filebeat /usr/share/filebeat/filebeat.yml && \
    chmod go-w /usr/share/filebeat/filebeat.yml && \
    curl https://raw.githubusercontent.com/logzio/public-certificates/master/TrustExternalCARoot_and_USERTrustRSAAAACA.crt -o /usr/share/filebeat/Logzio_CA_Root.crt && \
    chgrp filebeat /usr/share/filebeat/Logzio_CA_Root.crt

# Stay as root so we can read logs in /var/lib/docker/containers/*/*.log
