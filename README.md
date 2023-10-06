# Alpine
![size](https://img.shields.io/docker/image-size/11notes/alpine/3.18?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/alpine?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/alpine?color=2b75d6) ![activity](https://img.shields.io/github/commit-activity/m/11notes/docker-alpine?color=c91cb8) ![commit-last](https://img.shields.io/github/last-commit/11notes/docker-alpine?color=c91cb8)

Run Alpine Linux. Small, lightweight, secure and fast 🏔️

## Run
```shell
docker run --name alpine \
  -d 11notes/alpine:[tag]
```

## Defaults
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | / | home directory of user docker |

## Parent
* [alpine](https://hub.docker.com/_/alpine)

## Built with and thanks to
* [Alpine Linux](https://alpinelinux.org)

## Tips
* Only use rootless container runtime (podman, rootless docker)
* Don't bind to ports < 1024 (requires root), use NAT/reverse proxy (haproxy, traefik, nginx)