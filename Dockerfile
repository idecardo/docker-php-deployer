ARG PHP_VERSION=8.0

FROM php:$PHP_VERSION-alpine

RUN apk add --update --no-cache \
    bash npm openssh-client rsync

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions \
        @composer \
        bcmath-$PHP_VERSION \
        bz2-$PHP_VERSION \
        exif-$PHP_VERSION \
        gd-$PHP_VERSION \
        gmp-$PHP_VERSION \
        pdo_mysql-$PHP_VERSION \
        zip-$PHP_VERSION

RUN rm -rf /tmp/* /var/cache/apk/* /var/tmp/*

WORKDIR /var/www
