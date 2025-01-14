![Banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# 🏔️ Alpine Linux
[<img src="https://img.shields.io/badge/github-source-blue?logo=github&color=040308">](https://github.com/11notes/docker-alpine)![size](https://img.shields.io/docker/image-size/11notes/alpine/3.21.2?color=0eb305)![version](https://img.shields.io/docker/v/11notes/alpine/3.21.2?color=eb7a09)![pulls](https://img.shields.io/docker/pulls/11notes/alpine?color=2b75d6)[<img src="https://img.shields.io/github/issues/11notes/docker-alpine?color=7842f5">](https://github.com/11notes/docker-alpine/issues)

**Alpine Linux with mimalloc for fastest multi-threaded memory allocation**

# SYNOPSIS 📖
**What can I do with this?** This image will give you a base Alpine image with some additional tweaks like some bin’s (curl, tini, shadow, tzdata) which are present by default and the mimalloc memory allocator which can be used for certain apps to deal with musl’s not so optimized malloc for multi-threading. It will also execute the script ```/usr/local/bin/entrypoint.sh``` via [tini](https://github.com/krallin/tini).

If used as a base image for your own image simply leave out your own **ENTRYPOINT** to use the default one and provide your own ```/usr/local/bin/entrypoint.sh```.

# COMPOSE ✂️
```yaml
name: "alpine"
services:
  alpine:
    image: "11notes/alpine:3.21.2"
    container_name: "alpine"
    environment:
      TZ: "Europe/Zurich"
    restart: "always"
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
| `DEBUG` | Show debug messages from image **not** app | |
| `LD_PRELOAD` | Set mimalloc as default memalloc | /usr/lib/libmimalloc.so |
| `MIMALLOC_LARGE_OS_PAGES` | Large memory pages by default | 1 |

# SOURCE 💾
* [11notes/alpine](https://github.com/11notes/docker-alpine)

# PARENT IMAGE 🏛️
* [scratch](https://hub.docker.com/_/scratch)

# BUILT WITH 🧰
* [mimalloc](https://github.com/microsoft/mimalloc)
* [alpine](https://alpinelinux.org)

# TIPS 📌
* Use a reverse proxy like Traefik, Nginx, HAproxy to terminate TLS with a valid certificate
* Use Let’s Encrypt certificates to protect your SSL endpoints

# ElevenNotes™️
This image is provided to you at your own risk. Always make backups before updating an image to a different version. Check the [releases](https://github.com/11notes/docker-alpine/releases) for breaking changes. If you have any problems with using this image simply raise an [issue](https://github.com/11notes/docker-alpine/issues), thanks . You can find all my repositories on [github](https://github.com/11notes?tab=repositories).