ARG PHP_VERSION
FROM php:${PHP_VERSION}-apache

# -------------------------
# Install system packages, PHP extensions
# -------------------------
RUN apt-get update && apt-get install -y \
    git curl zip unzip gnupg vim libzip-dev libpng-dev libonig-dev libxml2-dev sudo locales \
    libmagickwand-dev imagemagick \
    && docker-php-ext-install pdo pdo_mysql zip gd mbstring xml \
    && pecl install imagick-3.4.4 \
    && docker-php-ext-enable imagick \
    && echo "ru_RU.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen ru_RU.UTF-8 \
    && update-locale LANG=ru_RU.UTF-8 \
    && echo 'LANG=ru_RU.UTF-8' >> /etc/environment \
    && echo 'LANGUAGE=ru_RU:ru' >> /etc/environment \
    && echo 'LC_ALL=ru_RU.UTF-8' >> /etc/environment \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY php/imagick/policy.xml /etc/ImageMagick-6/policy.xml
COPY php/php.ini /usr/local/etc/php/php.ini

# -------------------------
# Configure Apache virtual host
# -------------------------
ARG APP_VHOST_DIR
ENV APP_VHOST_DIR=${APP_VHOST_DIR}
COPY ${APP_VHOST_DIR}/ezhpo.conf /etc/apache2/sites-available

RUN a2enmod rewrite \
    && a2dissite 000-default.conf \
    && a2ensite ezhpo.conf

# -------------------------
# Install Composer globally
# -------------------------
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# -------------------------
# Add user 'app' with sudo privileges
# -------------------------
ARG UID
ARG GID
ENV UID=${UID}
ENV GID=${GID}

RUN groupadd -g ${GID} app \
    && useradd -u ${UID} -g app -ms /bin/bash app \
    && usermod -aG sudo app \
    && echo "app ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER app

# -------------------------
# Set locale environment variables for the 'app' user
# -------------------------
RUN echo 'export LANG=ru_RU.UTF-8' >> /home/app/.bashrc \
    && echo 'export LANGUAGE=ru_RU:ru' >> /home/app/.bashrc \
    && echo 'export LC_ALL=ru_RU.UTF-8' >> /home/app/.bashrc

# -------------------------
# Install Node.js via NVM
# -------------------------
ENV NVM_DIR=/home/app/.nvm
ARG NODE_VERSION
ENV NODE_VERSION=${NODE_VERSION}

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && echo "export NVM_DIR=$NVM_DIR" >> /home/app/.bashrc \
    && echo "[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"" >> /home/app/.bashrc

ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# -------------------------
# Set working directory
# -------------------------
WORKDIR /var/www/ezhpo
