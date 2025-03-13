ARG PHP_VERSION
FROM php:${PHP_VERSION}-apache

RUN apt-get update
RUN apt-get install -y \
    git curl zip unzip gnupg vim libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip gd mbstring xml

RUN a2enmod rewrite

ENV NVM_DIR=/root/.nvm
ARG NODE_VERSION
ENV NODE_VERSION=${NODE_VERSION}

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    echo "source $NVM_DIR/nvm.sh" >> /root/.bashrc

ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

WORKDIR /var/www