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
    && pecl install oauth-1.2.3 \
        && echo "extension=oauth.so" >> /etc/php5/apache2/conf.d/oauth.ini \
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

# Copy webdev php.ini file for development
COPY php.ini /etc/php5/apache2/

# Add vhosts and restart apache
ADD ./sites-available /etc/apache2/sites-available/

# Setup web root
WORKDIR /localsite/eclipse.local
COPY index.php /localsite/eclipse.local/
RUN chown -R www-data:www-data /localsite \
    && /etc/init.d/apache2 restart

COPY docker-php-entrypoint /usr/local/bin/
COPY apache2-foreground /usr/local/bin/

# Expose port 80
EXPOSE 80

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["apache2-foreground"]