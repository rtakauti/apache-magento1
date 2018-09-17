FROM php:7.0-apache
MAINTAINER Rubens Takauti <rtakauti@hotmail.com>

# Install GD
RUN apt-get update \
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng12-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

# Install MCrypt
RUN apt-get update \
    && apt-get install -y libmcrypt-dev \
    && docker-php-ext-install mcrypt

# Install Intl
RUN apt-get update \
    && apt-get install -y libicu-dev \
    && docker-php-ext-install intl

RUN pecl config-set preferred_state beta \
    && pecl install -o -f xdebug \
    && rm -rf /tmp/pear \
    && pecl config-set preferred_state stable

COPY ./xdebug.ini /usr/local/etc/php/conf.d/

RUN docker-php-ext-enable xdebug

# Install Mysql
RUN docker-php-ext-install mysqli pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Install mbstring
RUN docker-php-ext-install mbstring

# Install soap
RUN apt-get update \
    && apt-get install -y libxml2-dev \
    && docker-php-ext-install soap

# Install opcache
RUN docker-php-ext-install opcache

# Install PHP zip extension
RUN docker-php-ext-install zip

# Install Git
RUN apt-get update \
    && apt-get install -y git

# Install xsl
RUN apt-get update \
    && apt-get install -y libxslt-dev \
    && docker-php-ext-install xsl

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Additional PHP ini configuration
COPY ./php.ini /usr/local/etc/php/conf.d/


# Install MySQL CLI Client
RUN apt-get update \
    && apt-get install -y mysql-client


COPY  ./magento1.tar.gz /var/www/html/




RUN chmod 777 /var/www/html/magento1.tar.gz \
    && chown www-data:www-data /var/www/html/magento1.tar.gz

RUN  curl https://raw.githubusercontent.com/jreinke/modgit/master/modgit > modgit \
     && chmod +x modgit \
     && mv modgit /usr/local/bin

EXPOSE 443

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]