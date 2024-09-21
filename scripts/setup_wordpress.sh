#!/bin/bash

# Function to check and install a package if not already installed
install_if_not_installed() {
  if ! dpkg -l | grep -q "$1"; then
    echo "Installing $1..."
    sudo apt-get install -y "$1"
  else
    echo "$1 is already installed."
  fi
}

# Update package index
sudo apt-get update -y

# Install Apache
install_if_not_installed apache2

# Install PHP and required extensions
install_if_not_installed php
install_if_not_installed libapache2-mod-php
install_if_not_installed php-mysql
install_if_not_installed php-curl
install_if_not_installed php-xml
install_if_not_installed php-mbstring
install_if_not_installed php-zip

# Install MySQL (or MariaDB)
install_if_not_installed mysql-server



# Set permissions for the WordPress directory (assuming the files are already in place)
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Create wp-config.php file if it doesn't exist
if [ ! -f "/var/www/html/wp-config.php" ]; then
  echo "Creating wp-config.php file..."
  
  # Sample wp-config.php setup
  cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
  
  # Set your database details
  DB_NAME='amodh'
  DB_USER='admin'
  DB_PASSWORD='Amodh1234'

  # Update wp-config.php with the database details
  sed -i "s/database_name_here/${DB_NAME}/" /var/www/html/wp-config.php
  sed -i "s/username_here/${DB_USER}/" /var/www/html/wp-config.php
  sed -i "s/password_here/${DB_PASSWORD}/" /var/www/html/wp-config.php

  echo "wp-config.php has been created with database details."
else
  echo "wp-config.php already exists."
fi

# Restart Apache to apply changes
sudo systemctl restart apache2

echo "WordPress setup completed! Don't forget to secure your MySQL installation."
