![Banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# 🏔️ Alpine Linux
[<img src="https://img.shields.io/badge/github-source-blue?logo=github&color=040308">](https://github.com/11notes/docker-alpine)![size](https://img.shields.io/docker/image-size/11notes/alpine/3.21.3?color=0eb305)![version](https://img.shields.io/docker/v/11notes/alpine/3.21.3?color=eb7a09)![pulls](https://img.shields.io/docker/pulls/11notes/alpine?color=2b75d6)[<img src="https://img.shields.io/github/issues/11notes/docker-alpine?color=7842f5">](https://github.com/11notes/docker-alpine/issues)

**Alpine Linux with mimalloc for fastest multi-threaded memory allocation**

# MAIN TAGS 🏷️
These are the main tags for the image. There is also a tag for each commit and its shorthand sha256 value.

* [3.21.3](https://hub.docker.com/r/11notes/alpine/tags?name=3.21.3)
* [stable](https://hub.docker.com/r/11notes/alpine/tags?name=stable)
* [latest](https://hub.docker.com/r/11notes/alpine/tags?name=latest)


# SYNOPSIS 📖
**What can I do with this?** This image will give you a base Alpine image with some additional tweaks like some bin’s (curl, tini, shadow, tzdata) which are present by default and the mimalloc memory allocator which can be used for certain apps to deal with musl’s not so optimized malloc for multi-threading. It will also execute the script ```/usr/local/bin/entrypoint.sh``` via [tini](https://github.com/krallin/tini).

If used as a base image for your own image simply leave out your own **ENTRYPOINT** to use the default one and provide your own ```/usr/local/bin/entrypoint.sh```.

# BUILD 🚧
```dockerfile
FROM 11notes/alpine:stable
# switch to root during setup
USER root
# setup your app
RUN set -ex; \
  setup your app
# add custom entrypoint to image
COPY ./entrypoint.sh /usr/local/bin
# start image as 1000:1000
USER docker
```

# DEFAULT SETTINGS 🗃️
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user name |
| `uid` | 1000 | [user identifier](https://en.wikipedia.org/wiki/User_identifier) |
| `gid` | 1000 | [group identifier](https://en.wikipedia.org/wiki/Group_identifier) |
| `home` | / | home directory of user docker |

# ENVIRONMENT 📝
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Will activate debug option for container image and app (if available) | |
| `LD_PRELOAD` | Set mimalloc as default memalloc | /usr/lib/libmimalloc.so |
| `MIMALLOC_LARGE_OS_PAGES` | Large memory pages by default | 1 |

# SOURCE 💾
* [11notes/alpine](https://github.com/11notes/docker-alpine)

# PARENT IMAGE 🏛️
* [scratch](https://hub.docker.com/_/scratch)

# BUILT WITH 🧰
* [mimalloc](https://github.com/microsoft/mimalloc)
* [alpine](https://alpinelinux.org)

# GENERAL TIPS 📌
* Use a reverse proxy like Traefik, Nginx, HAproxy to terminate TLS and to protect your endpoints
* Use Let’s Encrypt DNS-01 challenge to obtain valid SSL certificates for your services

    
# ElevenNotes™️
This image is provided to you at your own risk. Always make backups before updating an image to a different version. Check the [releases](https://github.com/11notes/docker-alpine/releases) for breaking changes. If you have any problems with using this image simply raise an [issue](https://github.com/11notes/docker-alpine/issues), thanks. If you have a question or inputs please create a new [discussion](https://github.com/11notes/docker-alpine/discussions) instead of an issue. You can find all my other repositories on [github](https://github.com/11notes?tab=repositories).