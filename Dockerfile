FROM alpine:3.4

ENV VERSION 0.5.0-1

ENV USER_ID 1000
ENV GROUP_ID 1000

RUN apk --update add \
   bash \
   curl \
   git \
   g++ \
   make \
   openssh \
   openssl \
   openssl-dev \
   libstdc++ \
   libgcc \
   gpgme \
   && curl -L https://github.com/AGWA/git-crypt/archive/debian/$VERSION.tar.gz | tar zxv -C /var/tmp \
   && cd /var/tmp/git-crypt-debian-$VERSION && make && make install PREFIX=/usr/local \
   && rm -rf /var/tmp/* \
   && apk del curl g++ make openssh openssl-dev \
   && rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/local/bin/git-crypt"]
WORKDIR /repo

RUN addgroup -g ${GROUP_ID}  gitcrypt                                      && \
    adduser -D -H -s /usr/sbin/nologin -u ${USER_ID} -G gitcrypt gitcrypt

USER gitcrypt
