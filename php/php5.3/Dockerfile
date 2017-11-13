###
# Copyright (c) 2017 Eclipse Foundation and others.
# 
# This program and the accompanying materials are made 
# available under the terms of the Eclipse Public License 2.0 
# which accompanies this distribution, and is available
# at http://eclipse.org/legal/epl-2.0
###

FROM ubuntu:12.04
MAINTAINER Christopher Guindon <chris.guindon@eclipse.org>

# Setup home-data web root
WORKDIR /home

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng12-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev \
        apache2 \
        php5 \
        php5-cli \
        libapache2-mod-php5 \
        php5-mysql \
        php5-pgsql \
        php5-gd \
        php-pear \ 
        php5-json \
        build-essential \
        php5-dev \
        libpcre3-dev \
        php5-ldap \
        php5-curl \
        git \
        php5-mcrypt \
        php5-xdebug \
    && pecl install oauth-1.2.3 \
        && echo "extension=oauth.so" >> /etc/php5/apache2/conf.d/oauth.ini \
    && pecl install xdebug-2.2.7 \
        && echo "extension=xdebug.so" >> /etc/php5/apache2/conf.d/xdebug.ini \
    && version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
        && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
        && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
        && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
        && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > /etc/php5/cli/conf.d/blackfire.ini \
    && pecl install uploadprogress \
        && echo "extension=uploadprogress.so" >> /etc/php5/apache2/conf.d/uploadprogress.ini \
    && pecl install apcu-4.0.11 \
        && echo extension=apcu.so > /etc/php5/apache2/conf.d/apcu.ini \
    && DEBIAN_FRONTEND=noninteractive apt-get -y autoclean && apt-get -y autoremove \
    && git clone --recursive git://github.com/chrisguindon/eclipsefdn-home-data.git data \
    && a2enmod alias authz_host deflate dir expires headers mime php5 rewrite ssl setenvif \
    && chown -R www-data:www-data /home/data/

# Setup web root
WORKDIR /var/www/html

# Update document root to match php5.5 and php5.6
RUN sed -ri -e 's!/var/www!/var/www/html!g' /etc/apache2/sites-available/default*

COPY index.php /var/www/html
RUN chown -R www-data:www-data /var/www/html \
    && /etc/init.d/apache2 reload

COPY docker-php-entrypoint /usr/local/bin/
COPY apache2-foreground /usr/local/bin/

# Expose port 80
EXPOSE 80

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["apache2-foreground"]