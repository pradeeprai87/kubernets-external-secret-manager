# Use the official PHP image
FROM php:7.4-apache

# Copy the PHP source code to the Apache web directory
COPY . /var/www/html/

# Expose port 80
EXPOSE 80

