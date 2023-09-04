FROM php:7.4-fpm-alpine3.16
USER root
RUN apk update
RUN apk add --no-cache \
    build-base \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    bzip2-dev \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    curl \
    python3 \
    git \
    libxml2-dev \
    zlib-dev \
    libbz2 \
    openssl-dev \
    libxslt-dev \
    sqlite-dev \
    graphicsmagick \
    musl-locales \
    gmp-dev \
    make \
    gcc \
    autoconf \
    ghostscript \
    nfs-utils \
    libc-dev \
    pkgconfig \
    libgd \
    gd-dev \
    libressl-dev \
    oniguruma-dev \
    mariadb-client \
    imagemagick-dev \
    icu-dev \
    libcurl \
    curl-dev \
    gettext-dev \
    libzip-dev \
    shadow \
    mysql-client \
    bash

RUN apk upgrade --no-cache --ignore alpine-baselayout
RUN pecl install imagick
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd shmop \
                          intl \
                          mbstring \
                          opcache \
                          pdo \
                          soap \
                          xml \
                          bz2 \
                          curl \
                          fileinfo\
                          ftp \
                          gettext \
                          simplexml \
                          tokenizer \
                          xsl \
                          pdo_mysql \
                          pdo_sqlite \
                          mysqli \
                          bcmath \
                          gmp \
                          zip \
                          sockets

RUN pecl install apcu-5.1.22
RUN pecl install redis
RUN pecl install ast-1.1.0
RUN docker-php-ext-enable apcu intl redis ast
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version
RUN yes | pecl install xdebug-3.1.6
COPY ./conf.d/ /usr/local/etc/php/conf.d/
RUN mkdir -p /usr/share/nginx/html/app
RUN chown -R www-data.www-data /usr/share/nginx/html/
USER www-data
WORKDIR /usr/share/nginx/html/app
EXPOSE 9000
CMD ["php-fpm"]