###
# Copyright (c) 2017 Eclipse Foundation and others.
# 
# This program and the accompanying materials are made 
# available under the terms of the Eclipse Public License 2.0 
# which accompanies this distribution, and is available
# at http://eclipse.org/legal/epl-2.0
###

FROM php:5.6-apache
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
        git

# Install the PHP mcrypt extention
RUN docker-php-ext-install mcrypt

# Install the PHP pdo_mysql extention
RUN docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql
    
# Install the PHP pdo_pgsql extention
RUN docker-php-ext-install pdo_pgsql

# Install the PHP gd library
RUN docker-php-ext-install gd && \
    docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

# Install Php Redis Extension
RUN pecl install -o -f redis \
  &&  rm -rf /tmp/pear \
  &&  docker-php-ext-enable redis 

# Install the mongodb extension
RUN pecl install mongodb && \
  docker-php-ext-enable mongodb 

# Install the zip extension
RUN docker-php-ext-install zip 
    
# Install the bcmath extension
RUN docker-php-ext-install bcmath 
    
# Install the php memcached extension
RUN pecl install memcached-2.2.0 && \
  docker-php-ext-enable memcached 

# Install the mysql/mysqli extension
RUN docker-php-ext-install mysql && \
  docker-php-ext-install mysqli 

# Install the ldap extension
RUN apt-get update -yqq && \
  apt-get install -y libldap2-dev && \
  docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
  docker-php-ext-install ldap 

# Install image optimization extentions
RUN apt-get update -yqq && \
  apt-get install -y --force-yes jpegoptim optipng pngquant gifsicle 

# Install image imagick
RUN apt-get update -y && \
  apt-get install -y libmagickwand-dev imagemagick && \ 
  pecl install imagick && \
  docker-php-ext-enable imagick

# Install oauth extention
RUN pecl install oauth-1.2.3 && \
    echo "extension=oauth.so" >> $PHP_INI_DIR/conf.d/oauth.ini

# Install blackfire profiler extension
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini
 
# Only enable relevant Apache modules.
#RUN printf "*" | a2dismod
RUN a2enmod alias authz_host deflate dir expires headers mime php5 rewrite ssl setenvif

# Install Uploadprogress
RUN pecl install uploadprogress && \
    echo "extension=uploadprogress.so" >> $PHP_INI_DIR/conf.d/uploadprogress.ini

# Install APC
RUN pecl install apcu-4.0.11 \
    && echo extension=apcu.so > $PHP_INI_DIR/conf.d/apcu.ini

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

# Copy php.ini file for development
COPY php.ini /usr/local/etc/php/

ADD ./sites-available /etc/apache2/sites-available/
RUN /etc/init.d/apache2 restart