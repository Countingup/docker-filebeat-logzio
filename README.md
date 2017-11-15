# filebeat-logzio

[![Docker Automated buil](https://img.shields.io/docker/build/countingup/filebeat-logzio.svg)](https://hub.docker.com/r/countingup/filebeat-logzio/builds/)

> WARNING
>
> If you run this container with the host's docker socket bind mounted then you are granting filebeat root access to that host.
>
> Consider carefully where you run this, what other mitigating controls you put in place, and whether you trust the filebeat authors. If you don't understand this warning you shouldn't run this image!

The [filebeat](https://www.elastic.co/products/beats/filebeat) log shipper, configured to ship docker logs from the underlying host to [logz.io](https://logz.io) (which exposes logstash over TLS). Built on top of [docker.elastic.co/beats/filebeat:6.0.0-rc2](https://www.elastic.co/guide/en/beats/filebeat/6.0/running-on-docker.html) which is a beta release, not a stable release.

Expects a Logz.io token in the environment variable `LOGZIO_TOKEN`. Expects to find the hosts docker socket at `/var/run/docker.sock` (to enrich Docker logs with Docker metadata), the hosts Docker logs at `/var/lib/docker/containers` and the hosts log folder at `/var/log` (our config specifically looks for /var/log/syslog which contains everything of interest on [RancherOS](http://rancher.com/rancher-os/)). Runs filebeat as the root user so that it has access to these (the Docker log files are owned by root, the filebeat user is not in the docker group).

Customise filebeat.yml to suit your own needs, the version in the repo excludes some log events by container name and log content (for noisy Rancher components), and enriches them with both [docker](https://www.elastic.co/guide/en/beats/filebeat/6.0/add-docker-metadata.html) and [cloud provider](https://www.elastic.co/guide/en/beats/filebeat/6.0/add-cloud-metadata.html) metadata.

## Build locally

```
$ cd docker-filebeat-logzio
$ docker build -t countingup/filebeat-logzio .
```

## Run (will pull from dockerhub)

```
$ docker run -v /var/run/docker.sock:/var/run/docker.sock \
             -v /var/lib/docker/containers:/var/lib/docker/containers \
             -v /var/log:/var/log \
             -e'LOGZIO_TOKEN=<token goes here>' \
             countingup/filebeat-logzio
```
