![Banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# 🏔️ Alpine Linux
![size](https://img.shields.io/docker/image-size/11notes/alpine/3.19.1?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/alpine/3.19.1?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/alpine?color=2b75d6) ![activity](https://img.shields.io/github/commit-activity/m/11notes/docker-alpine?color=c91cb8) ![commit-last](https://img.shields.io/github/last-commit/11notes/docker-alpine?color=c91cb8) ![stars](https://img.shields.io/docker/stars/11notes/alpine?color=e6a50e)

# SYNOPSIS
What can I do with this? This image will give you a base Alpine image with some additional tweaks like some bin’s which are present by default and the mimalloc memory allocator which can be used for certain apps to deal with musl’s not so optimized malloc for multi threading. 

# RUN
```shell
docker run --name alpine \
  -d 11notes/:[tag]
```

# EXAMPLES
/usr/lib/libmimalloc.so.2
```shell
export LD_PRELOAD=/usr/lib/libmimalloc.so.2
```

# DEFAULT SETTINGS
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | / | home directory of user docker |

# ENVIRONMENT
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Show debug information | |

# BUILT WITH
* [mimalloc](https://github.com/microsoft/mimalloc)
* [alpine](https://alpinelinux.org)

# TIPS
* Only use rootless container runtime (podman, rootless docker)
* Allow non-root ports < 1024 via `echo "net.ipv4.ip_unprivileged_port_start=53" > /etc/sysctl.d/ports.conf`
* Use a reverse proxy like Traefik, Nginx to terminate TLS with a valid certificate
* Use Let’s Encrypt certificates to protect your SSL endpoints

# ElevenNotes<sup>™️</sup>
This image is provided to you at your own risk. Always make backups before updating an image to a new version. Check the changelog for breaking changes.
    