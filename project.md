${{ content_synopsis }} This image will give you a base Alpine image with some additional tweaks like some bin’s (curl, tini, shadow, tzdata) which are present by default and the mimalloc memory allocator which can be used for certain apps to deal with musl’s not so optimized malloc for multi-threading. It will also execute the script ```/usr/local/bin/entrypoint.sh``` via [tini](https://github.com/krallin/tini).

If used as a base image for your own image simply leave out your own **ENTRYPOINT** to use the default one and provide your own ```/usr/local/bin/entrypoint.sh```.

${{ content_compose }}

${{ content_build }}

${{ content_defaults }}

${{ content_environment }}

${{ content_source }}

${{ content_parent }}

${{ content_built }}

${{ content_tips }}