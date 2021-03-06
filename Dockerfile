FROM ubuntu:20.10

ENV DEBIAN_FRONTEND noninteractive

#Set variables
ENV APPPORT=8081

RUN apt-get update -yqq --fix-missing

RUN apt-get install -y software-properties-common wget locales

RUN apt-get remove -y --purge php*

RUN locale-gen en_US.UTF-8
RUN export LANG=C.UTF-8
RUN export LC_ALL=C.UTF-8

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y

# Update repo and install lamp, php, php dependencies, and phpmyadmin
RUN apt-get update -yqq --fix-missing

RUN apt-get -yqq --fix-missing install \
      build-essential \
      apache2 \
      curl \
      git \
      wget \
      sqlite3 \
      libpng-dev \
      libc-client-dev \
      zip \
      unzip \
      php7.4 \
      libapache2-mod-php7.4 \
      php7.4-cli \
      php7.4-mbstring \
      php7.4-mysql \
      php7.4-curl \
      php7.4-json \
      php7.4-intl \
      php7.4-gd \
      php7.4-xml \
      php7.4-zip \
      php7.4-bz2 \
      php7.4-opcache \
      php7.4-pgsql \
      php7.4-sqlite3\
      php7.4-intl \
      php7.4-bcmath \
      php7.4-soap \
      php7.4-readline


##########  Node + Yarn install  ###############
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN curl -sL https://deb.nodesource.com/setup_15.x | bash -

RUN apt-get update -yqq && apt-get -yqq --fix-missing install nodejs yarn

##########  APACHE  ##############
RUN service apache2 restart

COPY laravel.conf /etc/apache2/sites-available/laravel.conf

#This will only work with GNU sed
RUN sed -i.bak "s/Listen 80/Listen 80\n\nListen $APPPORT\n/" /etc/apache2/ports.conf

RUN a2ensite 000-default && \
    a2ensite laravel && \
    a2enmod rewrite

RUN echo 'ServerName localhost' >> /etc/apache2/apache2.conf
RUN service apache2 restart

# Downloading and installing composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 80
EXPOSE 8081

WORKDIR /var/www/html
