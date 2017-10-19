###
# Copyright (c) 2017 Eclipse Foundation and others.
# 
# This program and the accompanying materials are made 
# available under the terms of the Eclipse Public License 2.0 
# which accompanies this distribution, and is available
# at http://eclipse.org/legal/epl-2.0
###

FROM php:5.6-apache
MAINTAINER Christopher Guindon <chris.guindon@eclipse-foundation.org>

# Add default VirtualHost file
ADD ./sites-available /etc/apache2/sites-available/

# Copy php.ini file for development
COPY php.ini /usr/local/etc/php/

# Setup home-data root
WORKDIR /home

RUN set -ex \ 
    && buildDeps=' \
        libjpeg62-turbo-dev \
        libpng12-dev \
        libpq-dev \
        libldap2-dev \
        libmcrypt-dev \
        libz-dev \
        libmemcached-dev \
    ' \ 
    && apt-get update && apt-get install -y --no-install-recommends $buildDeps curl git \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd \
        --with-jpeg-dir=/usr \
        --with-png-dir=/usr \
    && docker-php-ext-install -j "$(nproc)" bcmath gd mbstring pdo pdo_mysql pdo_pgsql mysql zip mcrypt \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
        && docker-php-ext-install ldap \
    && pecl install oauth-1.2.3 \
        && echo "extension=oauth.so" >> $PHP_INI_DIR/conf.d/oauth.ini \
    && pecl install -o -f redis \
        && rm -rf /tmp/pear \
        && docker-php-ext-enable redis  \
    && pecl install memcached-2.2.0 \
        && docker-php-ext-enable memcached \
    && pecl install uploadprogress \
        && echo "extension=uploadprogress.so" >> $PHP_INI_DIR/conf.d/uploadprogress.ini \
    && pecl install apcu-4.0.11 \
        && echo extension=apcu.so > $PHP_INI_DIR/conf.d/apcu.ini \
    && version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
        && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
        && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
        && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
        && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && apt-mark manual \
        libjpeg62-turbo \
        libpq5 \
    && apt-get purge -y --auto-remove $buildDeps \
    && a2enmod alias authz_host deflate dir expires headers mime php5 rewrite setenvif \
    && git clone --recursive git://github.com/chrisguindon/eclipsefdn-home-data.git data  \
    && chown -R www-data:www-data /home/data/

# Setup web root
WORKDIR /localsite/eclipse.local
COPY index.php /localsite/eclipse.local/ 
RUN chown -R www-data:www-data /localsite \
    && /etc/init.d/apache2 restart