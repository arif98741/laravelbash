#!/bin/bash
#Version: 0.0.1
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
    echo "----Version: 0.0.1---"
    echo "--https://github.com/arif98741----"
    echo "============================================================"

    #variables for using in bash script
    #this is sensitive information. Please keep your head cool before changing this variables
    project='something.com'                            #your project name. you should change it according to your domain name
    clone_dir="/var/www/$project"                      #where to clone . no need to change
    clone_url='git@github.com:arif98741/something.git' #your git repository url example: git@url.com:user/repo.git
    server='nginx'
    php_version=4 # here 4 refers to 7.4; In same way 3 refers to 7.3
    permission_755=755
    permission_756=756
    permission_775=775
    permission_777=777

    echo

    echo "=========================================================="
    echo "Step1: SSH key generate"
    echo "============================================================"
    echo "Generating SSH Key. After Generating please copy and paste it to "
    echo

    echo 'https://github.com/settings/keys'

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
        echo "Installing PHP"
        echo

        # shellcheck disable=SC2091
        $(php_installation $php_version)

        echo "Successfully Installed PHP 7.$php_version"
        echo

      fi

      echo "=========================================================="
      echo "Step3: Nginx Installation"
      echo "============================================================"
      echo "Installing Nginx"

      echo

      sudo apt update
      sudo apt install nginx

      echo

      echo "Nginx Successfully Installed"
      nginx -v
      echo

      echo "Showing Ufw Permissions"
      ufw app list
      echo

      echo "Allowing Ufw Permissions"

      ufw allow 'Nginx HTTP'
      echo

      echo "Nginx HTTP Allowed Successfully. Listed Below"
      ufw status
      echo

      echo "Server Status"
      #systemctl status nginx

      echo

      echo "Booting.."
      systemctl restart nginx
      echo

      echo "Nginx Booted..."

      echo

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
      echo "Step4: Manage Nginx Server Block"
      echo "============================================================"
      echo

      # shellcheck disable=SC2162
      read -p "Do you want to manage nginx server block " decision
      if [ "$decision" = 'yes' ]; then
        echo \
          echo 'Creating server block'
        echo

        # shellcheck disable=SC2162
        read -p "Do you want to copy pre-built default file? yes/no: " copydecision
        if [ "$copydecision" = 'yes' ]; then #this will handle wheather new file will be created or
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
  apt-get install php7."$1" -y
  # shellcheck disable=SC2086
  apt-get install php7.$1-fpm php7.$1-cli php7.$1-mysql php7.$1-curl php7.$1-json -y
  systemctl start php7."$1"-fpm
  # shellcheck disable=SC2086
  systemctl enable php7.$1-fpm
}

run_script
