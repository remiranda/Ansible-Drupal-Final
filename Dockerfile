FROM drupal:8.2-apache
MAINTAINER Rene Miranda <remiranda08@gmail.com>

# Install packages.
RUN apt-get update
RUN apt-get install -y \
	vim \
	git \
	php5-cli \
	php5-xdebug \
	mysql-client \
	wget \
	iputils-ping \
	zip \
	unzip
RUN apt-get clean

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush with composer.
RUN composer global require drush/drush:8

# Configure composer bin path for drush
RUN echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> /root/.bashrc
ENV PATH /root/.composer/vendor/bin:$PATH

# Setup PHP.
COPY ./php-docker.ini /usr/local/etc/php/conf.d/
COPY ./php-docker.ini /etc/php5/cli/conf.d/

# Map directory ownership (docker-machine-nfs setup).
RUN usermod -u 501 www-data
RUN usermod -G dialout www-data
