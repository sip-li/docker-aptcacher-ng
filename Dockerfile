FROM    callforamerica/debian:jessie

MAINTAINER joe <joe@valuphone.com>

RUN     useradd \
            --home-dir /var/cache/apt-cacher-ng \
            --create-home \
            --shell=/bin/bash \
            --user-group apt-cacher-ng

RUN     apt-get update && \
            apt-get install -y apt-cacher-ng && \
            apt-clean --aggressive

RUN     sed -ir 's/# ForeGround: 0/ForeGround: 1/' /etc/apt-cacher-ng/acng.conf 

COPY    entrypoint /entrypoint

VOLUME  ["/var/cache/apt-cacher-ng"]

EXPOSE  3142

ENV     APTCACHER_PORT=3142 \
        APTCACHER_BIND_ADDR=0.0.0.0 \
        APTCACHER_EXPIRE_THRESHOLD=4

# USER    apt-cacher-ng
WORKDIR     /var/cache/apt-cacher-ng

ENTRYPOINT  ["/dumb-init", "--"]
CMD         ["/entrypoint"]
