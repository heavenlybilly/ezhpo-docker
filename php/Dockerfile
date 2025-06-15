ARG PHP_VERSION
FROM php:${PHP_VERSION}-apache

RUN apt-get update
RUN apt-get install -y \
    git curl zip unzip gnupg vim libzip-dev libpng-dev libonig-dev libxml2-dev sudo \
    && docker-php-ext-install pdo pdo_mysql zip gd mbstring xml

# Enable virtual host
ARG APP_VHOST_DIR
ENV APP_VHOST_DIR=${APP_VHOST_DIR}
COPY ${APP_VHOST_DIR}/ezhpo.conf /etc/apache2/sites-available

RUN a2enmod rewrite \
    && a2dissite 000-default.conf \
    && a2ensite ezhpo.conf

# Install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Set up locales
RUN apt-get update && apt-get install -y locales \
    && echo "ru_RU.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen ru_RU.UTF-8 \
    && update-locale LANG=ru_RU.UTF-8 \
    && echo 'LANG=ru_RU.UTF-8' >> /etc/environment \
    && echo 'LANGUAGE=ru_RU:ru' >> /etc/environment \
    && echo 'LC_ALL=ru_RU.UTF-8' >> /etc/environment

# Add new user
ARG UID
ARG GID
ENV UID=${UID}
ENV GID=${GID}

RUN groupadd -g ${GID} app \
    && useradd -u ${UID} -g app -ms /bin/bash app \
    && usermod -aG sudo app \
    && echo "app ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN echo 'export LANG=ru_RU.UTF-8' >> /home/app/.bashrc \
    && echo 'export LANGUAGE=ru_RU:ru' >> /home/app/.bashrc \
    && echo 'export LC_ALL=ru_RU.UTF-8' >> /home/app/.bashrc

USER app

# Install NodeJs and NPM
ENV NVM_DIR=/home/app/.nvm
ARG NODE_VERSION
ENV NODE_VERSION=${NODE_VERSION}

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    echo "export NVM_DIR=$NVM_DIR" >> /home/app/.bashrc && \
    echo "[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"" >> /home/app/.bashrc

ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

WORKDIR /var/www/ezhpo
