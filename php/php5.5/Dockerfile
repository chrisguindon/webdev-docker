###
# Copyright (c) 2017 Eclipse Foundation and others.
# 
# This program and the accompanying materials are made 
# available under the terms of the Eclipse Public License 2.0 
# which accompanies this distribution, and is available
# at http://eclipse.org/legal/epl-2.0
###

FROM ubuntu:14.04
MAINTAINER Christopher Guindon <chris.guindon@eclipse.org>

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
        openssh-client \
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
        apt-transport-https \
        ca-certificates \
        git \
        php5-mcrypt

# Install oauth extention
RUN pecl install oauth-1.2.3 && \
    echo "extension=oauth.so" >> /etc/php5/apache2/conf.d/oauth.ini

# Install blackfire extention
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > /etc/php5/apache2/conf.d/blackfire.ini
 
# Only enable relevant Apache modules.
RUN a2enmod alias authz_host deflate dir expires headers mime php5 rewrite ssl setenvif

# Install Uploadprogress
RUN pecl install uploadprogress && \
    echo "extension=uploadprogress.so" >> /etc/php5/apache2/conf.d/uploadprogress.ini

# Install APC
RUN pecl install apcu-4.0.11 \
    && echo extension=apcu.so > /etc/php5/apache2/conf.d/apcu.ini

# Clean-up installation.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y autoclean && apt-get -y autoremove

# Setup home-data web root
WORKDIR /home
RUN git clone --recursive git://github.com/chrisguindon/eclipsefdn-home-data.git data
RUN chown -R www-data:www-data /home/data/
VOLUME /home

# Setup web root
WORKDIR /localsite/eclipse.local
COPY index.php /localsite/eclipse.local/
RUN chown -R www-data:www-data /localsite
VOLUME /localsite

# Copy php.ini file for developement
COPY php.ini /etc/php5/apache2/

# Add vhosts and restart apache
ADD ./sites-available /etc/apache2/sites-available/
RUN /etc/init.d/apache2 restart

# Copy entrypoint
COPY docker-php-entrypoint /usr/local/bin/
ENTRYPOINT ["docker-php-entrypoint"]

# Define working directory
WORKDIR /var/www/html

# Expose default web ports
EXPOSE 80

# Define CMD
COPY apache2-foreground /usr/local/bin/
CMD ["apache2-foreground"]