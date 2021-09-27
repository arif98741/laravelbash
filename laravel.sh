#run at laravel directory
project='gadgetandgear.com'                                #your project name
clone_dir="/var/www/$project"                              #where to clone
clone_url='git@github.com:arif98741/barcode_generator.git' #replace this with specific project ssh-url
permission_755=755
permission_756=756
permission_775=775
permission_777=777

#composer install
#cp .env.example .env
read -p "Have you edited the nginx, php, mysql previously, yes/no: " decision
if [ $decision = 'yes' ]; then

  echo \

  echo 'Success installed\n'
  nginx -v

  echo 'running script'

  php artisan key:generate
  php artisan config:cache
  php artisan optimize:clear
  php artisan view:cache

  echo \

  echo 'Artisan command executed'

  chgrp -R www-data storage $clone_dir/bootstrap/cache
  chmod -R ug+rwx $clone_dir/storage bootstrap/cache
  chmod -R $permission_775 $clone_dir
  chmod -R o+w $clone_dir/storage/

  chown -R www-data.www-data $clone_dir
  #chown -R www-data.www-data $clone_dir/storage
  #chown -R www-data.www-data $clone_dir/public/themes
  #chown -R www-data.www-data $clone_dir/public/vendor
  #chown -R www-data.www-data $clone_dir/public/storage
  #chown -R www-data.www-data $clone_dir/public/images
  #chown -R www-data.www-data $clone_dir/public/images/media

  group_read_permission=(#folders that needs read(R) permission

    storage
    public/themes
    public/vendor
    public/storage
  )

  for i in "${group_read_permission[@]}"; do
    chown -R www-data.www-data $clone_dir/$i
  done

  echo 'Success';
  echo \

  echo 'Thanks for using laravel bash script script'

else
  echo "Oh no you are lazy to edit .env file boss!"
fi
