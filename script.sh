#!/bin/bash
#Version: 0.0.5
#Script: Shell Script for Server Setup for Nginx
#Description: This is for configuring nginx, php and permission management.
# Some commands may not be executed successfully due to permission issue.
# This file is built for root user not others. To modify for others users , simply add 'sudo' as prefix
# of every command
# Issues and Security: This file is built for only single use. You are also free to use.
# You are fully responsible for if any damage happened due to use of this bash script. So, use it
# at your own risk

function run_script() {

  if cd /var/www; then

    echo "=========================================================="
    echo "Welcome to Shell for Server Setup Nginx"
    echo "Created By: Ariful Islam"
    echo "----Version: 0.0.5---"
    echo "--https://github.com/arif98741----"
    echo "============================================================"

    #variables for using in bash script
    #this is sensitive information. Please keep your head cool before changing this variables value
    project='something.com'                            #your project name. you should change it according based on domain name
    clone_dir="/var/www/html/$project"                 #where to clone . no need to change
    clone_url='git@github.com:arif98741/something.git' #your git repository url example: git@url.com:user/repo.git
    ssh_email='something@gmail.com'                    #this should be your github account email
    server='nginx'
    php_version="8.1" # refers to php 8.1; In same way you can install  7.2, 7.3, 7.4, 8.0, 8.1, 8.2
    permission_755=755

    echo

    echo "=========================================================="
    echo "Step1: SSH key generate"
    echo "============================================================"
    echo
    echo "Generate SSH Key. After Generating please copy and paste it to "
    echo

    echo 'https://github.com/settings/keys'

    # shellcheck disable=SC2162
    read -p "Do you want to generate ssh-key, yes/no: " decision
    if [ "$decision" = 'yes' ]; then
      echo "Generating SSH-Key for User $USER"
      echo

      ssh-keygen -t rsa -b 4096 -C "$ssh_email"

      echo "Successfully Generated Key for user $USER"
      echo

    fi

    echo
    ssh-keygen -y
    cat ~/.ssh/id_rsa.pub
    echo

    echo "Cloning $project from $clone_dir at $clone_dir"
    git clone $clone_url $clone_dir

    #if else condition for running further step

    # shellcheck disable=SC2162
    read -p "Have you copied and paste ssh key to github, yes/no: " decision

    if [ "$decision" = 'yes' ]; then
      echo "Excellent Boss!. "
      echo

      echo 'Running further script like nginx and so on ....'
      echo

      echo "=========================================================="
      echo "Step2: PHP Installation"
      echo "============================================================"

      # shellcheck disable=SC2162
      read -p "Do you want to install php, yes/no: " decision
      if [ "$decision" = 'yes' ]; then
        echo "Installing PHP $php_version"
        echo

        # shellcheck disable=SC2091
        $(php_installation $php_version)

        echo "Successfully Installed PHP $php_version"
        echo
      fi

      echo "=========================================================="
      echo "Step3: Composer Installation"
      echo "============================================================"

      # shellcheck disable=SC2162
      read -p "Do you want to install composer, yes/no: " decision
      if [ "$decision" = 'yes' ]; then
        echo "Installing composer"
        echo

        # shellcheck disable=SC2091
        $(composer_installation)
        echo
      fi

      echo "=========================================================="
      echo "Step4: Nginx Installation"
      echo "============================================================"
      # shellcheck disable=SC2162
      read -p "Do you want to install nginx, yes/no: " decision
      if [ "$decision" = 'yes' ]; then
        echo "Installing Nginx"
        echo
        echo

        sudo apt update
        sudo apt install nginx

        echo

        echo "Nginx Successfully Installed"
        echo

        nginx -v
        echo

        echo "Showing Ufw Permissions"
        ufw app list
        echo

        echo "Allowing Ufw Permissions"
        echo \

        ufw allow 'Nginx HTTP'
        echo \

        echo "Nginx HTTP Allowed Successfully. Listed Below"
        ufw status
        echo

        echo "==================================Showing Server Status================================"
        #systemctl status nginx

        echo \

        echo "Booting.."
        systemctl restart nginx
        echo

        echo "Nginx Booted..."

        echo
      fi

      echo "Adding Permission directory"
      # shellcheck disable=SC2086
      chown -R $USER:"$USER" $clone_dir

      echo

      echo "Now You are setting step of Creating Server Block"
      echo

      echo "Permission for $clone_dir"
      # shellcheck disable=SC2086
      chown -R $USER:"$USER" "/var/www/html"
      chmod -R $permission_755 $clone_dir
      echo

      echo "Permission given to $clone_url"

      echo

      echo "=========================================================="
      echo "Step5: Manage Nginx Server Block"
      echo "============================================================"
      echo

      # shellcheck disable=SC2162
      read -p "Do you want to manage nginx server block, yes/no " decision
      if [ "$decision" = 'yes' ]; then
        echo \
          echo 'Creating server block'
        echo

        # shellcheck disable=SC2162
        read -p "Do you want to copy pre-built default file? yes/no: " copydecision
        if [ "$copydecision" = 'yes' ]; then #this will handle whether new file will be created or not
          #nano /var/www/etc
          cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$project
          echo "New server block added $project"
          nano /etc/nginx/sites-available/$project
        else
          echo "You are editing the default nginx config"
          nano /etc/nginx/sites-available/default
        fi

        #nginx status
        nginx -t

        # shellcheck disable=SC2162
        read -p "Have you done editing? yes/no: " done_editing
        if [ "$done_editing" = 'yes' ]; then
          echo "Congratulations you have done editing configuration file"
        fi
        nginx -t
        systemctl restart nginx
      else
        echo 'Server Block Management ignored!'
      fi

      echo 'Script Execution Successfully Completed'
    fi

  else
    echo "Could not run script on this directory. Run this script in /var/www"
  fi
}

# install php
function php_installation() { #accepts one param version. don't change here. Change from php_version at the top of this script
  sudo apt install software-properties-common apt-transport-https -y
  sudo add-apt-repository ppa:ondrej/php -y
  apt-get install php"$1" -y
  # shellcheck disable=SC2086
  apt-get install php$1-fpm php$1-cli php$1-mysql php$1-curl php$1-json php$1-mbstring php$1-zip -y
  systemctl start php"$1"-fpm
  # shellcheck disable=SC2086
  systemctl enable php$1-fpm
}

# install composer
function composer_installation() { #accepts one param version. don't change here. Change from composer_Version at the top of this script
  curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
  # shellcheck disable=SC2034
  # shellcheck disable=SC2006
  HASH=$(curl -sS https://composer.github.io/installer.sig)
  php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer is verified'; } else { echo 'Installer is corrupted'; unlink('composer-setup.php'); } echo PHP_EOL;"
  sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
  echo

  echo "Successfully installed composer!. "

  echo
  composer --version

}

run_script
