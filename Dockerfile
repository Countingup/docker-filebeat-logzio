FROM docker.elastic.co/beats/filebeat:6.8.9

# Add custom filebeat config
COPY filebeat.yml /usr/share/filebeat/filebeat.yml

USER root

# Set permissions
RUN chgrp filebeat /usr/share/filebeat/filebeat.yml

# Get Logz.io CA cert, updated for CA change, see https://docs.logz.io/technical-notes/chain-of-trust/#replace-the-cert-file
RUN curl https://raw.githubusercontent.com/logzio/public-certificates/master/TrustExternalCARoot_and_USERTrustRSAAAACA.crt -o /usr/share/filebeat/Logzio_CA_Root.crt

# Set permissions
RUN chgrp filebeat /usr/share/filebeat/Logzio_CA_Root.crt

# Stay as root so we can read logs in /var/lib/docker/containers/*/*.log
