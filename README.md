# rtmp-replicator-docker

cine.io [Docker](https://docker.com/) container that receives incoming RTMP FLV streams and saves them as FLV files on a shared volume.


# Usage

```bash
$ boot2docker stop
$ VBoxManage sharedfolder add boot2docker-vm -name home -hostpath /Users
$ boot2docker up
$ docker run --rm -it -p 1935:1935 cine/rtmp-flv-record-docker
```
