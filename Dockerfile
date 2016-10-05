FROM    callforamerica/debian

MAINTAINER joe <joe@valuphone.com>

LABEL   app.name="aptcacher-ng" \
        app.version="0.8.0"

LABEL   APTCACHER_NG_VERSION=0.8.0

ENV     HOME=/opt/apt-cacher-ng

COPY    build.sh /tmp/build.sh
RUN     /tmp/build.sh

COPY    entrypoint /entrypoint

VOLUME  ["/var/cache/apt-cacher-ng"]

EXPOSE  3142

ENV     APTCACHER_PORT=3142 \
        APTCACHER_BIND_ADDR=0.0.0.0 \
        APTCACHER_EXPIRE_THRESHOLD=4

WORKDIR     /var/cache/apt-cacher-ng

ENTRYPOINT  ["/dumb-init", "--"]
CMD         ["/entrypoint"]
