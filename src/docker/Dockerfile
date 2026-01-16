FROM wordpress:6-php8.2-apache

# Install OpCache and other dependencies
RUN docker-php-ext-install opcache

# Install unzip and curl for downloading plugins
RUN apt-get update && apt-get install -y unzip curl && rm -rf /var/lib/apt/lists/*

# Download WooCommerce
RUN curl -o /tmp/woocommerce.zip -L https://downloads.wordpress.org/plugin/woocommerce.latest-stable.zip \
    && unzip /tmp/woocommerce.zip -d /usr/src/wordpress/wp-content/plugins/ \
    && rm /tmp/woocommerce.zip

# Download WP Offload Media Lite
RUN curl -o /tmp/amazon-s3-and-cloudfront.zip -L https://downloads.wordpress.org/plugin/amazon-s3-and-cloudfront.latest-stable.zip \
    && unzip /tmp/amazon-s3-and-cloudfront.zip -d /usr/src/wordpress/wp-content/plugins/ \
    && rm /tmp/amazon-s3-and-cloudfront.zip

# [DEMO KEY STEP] Copy Local Customized Theme to Image
# This allows CI/CD to update the site appearance when you push code changes.
# Path relative to build context (project root)
# The manual instructs users to edit 'theme_source', so we copy from there.
COPY theme_source/cosmetics-shop /usr/src/wordpress/wp-content/themes/cosmetics-shop

# Copy PHP config
COPY src/docker/uploads.ini /usr/local/etc/php/conf.d/uploads.ini

# Copy WordPress config
# Terraform injects env vars used by this config
COPY src/docker/wp-config.php /usr/src/wordpress/wp-config.php

# Fix permissions
RUN chown -R www-data:www-data /usr/src/wordpress/wp-content/plugins
RUN chown www-data:www-data /usr/src/wordpress/wp-config.php
