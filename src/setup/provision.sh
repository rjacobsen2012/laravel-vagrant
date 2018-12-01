#!/bin/bash

folder_name=$1
vagrant_ip=$2
db_user=$3
db_password=$4
vagrant_name=$5
php_version=$6

now=$(date +"%T")
echo $'\n\033[33;33m '$now' ========> The provisioning process will take 10-15 minutes. Go grab a drink :)'

now=$(date +"%T")
echo $'\n\033[33;33m '$now' ========> Provisioning virtual machine...'
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

locale-gen en_US.UTF-8 > /dev/null 2>&1
dpkg-reconfigure locales -f noninteractive > /dev/null 2>&1

usermod -a -G www-data vagrant

now=$(date +"%T")
echo $'\n\033[33;33m '$now' ========> Adding ppa:ondrej/php...'
add-apt-repository ppa:ondrej/php -y > /dev/null 2>&1
apt-get update -y > /dev/null 2>&1

now=$(date +"%T")
echo $'\n\033[33;33m '$now' ========> Checking PHP...'
phppresent=`which php`
if [ "$phppresent" = "" ]; then
    echo $'\n\033[33;33m '$now' ========> Adding php...'
    apt-get install -y python-software-properties build-essential tcl > /dev/null 2>&1
    apt-get update -y > /dev/null 2>&1
    apt-get install -y php$php_version > /dev/null 2>&1
    apt-get remove -y apache2 > /dev/null 2>&1
    apt-get install -y php$php_version-common php$php_version-dev php$php_version-cli php$php_version-fpm curl php$php_version-curl php$php_version-gd mcrypt php-mcrypt php$php_version-mysql php$php_version-imap php$php_version-mbstring nginx > /dev/null 2>&1
    apt-add-repository ppa:brightbox/ruby-ng-experimental -y > /dev/null 2>&1
    apt-get update -y > /dev/null 2>&1
    apt-get autoremove -y > /dev/null 2>&1
else
    echo $'\n\033[33;33m '$now' ========> php installed... moving on...'
fi

now=$(date +"%T")
echo $'\n\033[33;33m '$now' ========> Checking Redis...'
if [ ! -e /etc/systemd/system/redis.service ]; then
    echo $'\n\033[33;33m '$now' ========> Adding Redis...'
    cd /tmp
    curl -O http://download.redis.io/redis-stable.tar.gz > /dev/null 2>&1
    tar xzvf redis-stable.tar.gz > /dev/null 2>&1
    cd redis-stable
    make > /dev/null 2>&1
    make test > /dev/null 2>&1
    sudo make install > /dev/null 2>&1
    sudo mkdir /etc/redis > /dev/null 2>&1
    sudo cp /tmp/redis-stable/redis.conf /etc/redis > /dev/null 2>&1
    sed -i "s/supervised no/supervised systemd/g" /etc/redis/redis.conf > /dev/null 2>&1
    sed -i "s/#   supervised systemd      - no/#   supervised no      - no/g" /etc/redis/redis.conf > /dev/null 2>&1
    sed -i "s/dir .\//dir \/var\/lib\/redis/g" /etc/redis/redis.conf
    cp /var/www/$folder_name/setup/config/redis.service /etc/systemd/system/redis.service > /dev/null 2>&1
    sudo adduser --system --group --no-create-home redis > /dev/null 2>&1
    sudo mkdir /var/lib/redis > /dev/null 2>&1
    sudo chown redis:redis /var/lib/redis > /dev/null 2>&1
    sudo chmod 770 /var/lib/redis > /dev/null 2>&1
    sudo systemctl start redis > /dev/null 2>&1
    sudo systemctl enable redis > /dev/null 2>&1
else
    echo $'\n\033[33;33m '$now' ========> Redis installed... moving on...'
fi

now=$(date +"%T")
echo $'\n\033[33;33m '$now' ========> Checking if Redis is running...'
redisstatus=`sudo systemctl status redis`
if [[ $redisstatus = *"active (running)"* ]]; then
    echo $'\n\033[33;33m '$now' ========> Redis installed and running!'
else
    echo $'\n\033[0;31m '$now' ========> *** There was a problem installing redis! ***'
fi

now=$(date +"%T")
echo $'\n\033[33;33m '$now' ========> Checking GIT...'
gitpresent=`which git`
if [ "$gitpresent" = "" ]; then
    echo $'\n\033[33;33m '$now' ========> Installing Git...'
    apt-get install git -y > /dev/null 2>&1
else
    echo $'\n\033[33;33m '$now' ========> GIT installed... moving on...'
fi

postfix=`which postfix`

now=$(date +"%T")
if [ "$postfix" = "" ]; then
    echo $'\n\033[33;33m '$now' ========> Installing Postfix, mailutils...'
    echo postfix postfix/mailname string $folder_name | debconf-set-selections
    echo postfix postfix/main_mailer_type string 'Internet Site' | debconf-set-selections
    apt-get -qq install -y postfix > /dev/null 2>&1
    service postfix reload > /dev/null 2>&1
else
    echo $'\n\033[33;33m '$now' ========> Postfix installed... moving on...'
fi

mailcatcher=`which mailcatcher`

now=$(date +"%T")
if [ "$mailcatcher" = "" ]; then
    echo $'\n\033[33;33m '$now' ========> Installing Mailcatcher...'
    apt-get -qq -f -y install libsqlite3-dev ruby1.9.1-dev > /dev/null 2>&1

    sudo gem install mime-types --version "< 3" > /dev/null 2>&1
    sudo gem install --conservative mailcatcher > /dev/null 2>&1
    sudo sh -c "echo '@reboot root $(which mailcatcher) --ip=0.0.0.0' >> /etc/crontab"
    sudo update-rc.d cron defaults > /dev/null 2>&1
    sudo sh -c "echo 'sendmail_path = /usr/bin/env $(which catchmail)' >> /etc/php/$php_version/mods-available/mailcatcher.ini"
    sudo phpenmod -v ALL -s ALL mailcatcher
    sudo cp /var/www/$folder_name/setup/mailcatcher.conf /etc/init/mailcatcher.conf > /dev/null 2>&1
    sudo service php$php_version-fpm restart > /dev/null 2>&1
else
    echo $'\n\033[33;33m '$now' ========> Mailcatcher installed... moving on'
fi

now=$(date +"%T")
echo $'\n\033[33;33m '$now' ========> Installing Mysql...'
echo "mysql-server-5.7 mysql-server/root_password password $db_password" | debconf-set-selections
echo "mysql-server-5.7 mysql-server/root_password_again password $db_password" | debconf-set-selections

apt-get install mysql-server-5.7 -y > /dev/null 2>&1

now=$(date +"%T")
echo $'\n\033[33;33m '$now' ========> Configuring Nginx...'
cp /var/www/$folder_name/setup/config/nginx_vhost /etc/nginx/sites-available/$folder_name > /dev/null

sed -i "s/folder_name/$folder_name/g" /etc/nginx/sites-available/$folder_name
sed -i "s/php_version/$php_version/g" /etc/nginx/sites-available/$folder_name

ln -s /etc/nginx/sites-available/$folder_name /etc/nginx/sites-enabled/

rm -rf /etc/nginx/sites-available/default

service nginx restart > /dev/null 2>&1

xdebug=`dpkg -l | grep -i php-xdebug`

now=$(date +"%T")
if [ "$xdebug" = "" ]; then
    echo $'\n\033[33;33m '$now' ========> Installing Xdebug...'
    sudo apt-get -qq install -y php-xdebug > /dev/null 2>&1

cat << EOF | sudo tee -a /etc/php/$php_version/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_host=127.0.0.1
xdebug.remote_port=9000
xdebug.remote_autostart=0
xdebug.remote_connect_back=0
xdebug.max_nesting_level = 5000
EOF
else
    echo $'\n\033[33;33m '$now' ========> Xdebug installed... moving on'
fi

chmod -R o+w /var/www/$folder_name/storage

cd /var/www/$folder_name

sed -i "/DB_DATABASE/c\DB_DATABASE=$folder_name" /var/www/$folder_name/.env
sed -i "/DB_HOST/c\DB_HOST=$vagrant_ip" /var/www/$folder_name/.env
sed -i "/DB_USERNAME/c\DB_USERNAME=$db_user" /var/www/$folder_name/.env
sed -i "/DB_PASSWORD/c\DB_PASSWORD=$db_password" /var/www/$folder_name/.env
sed -i "/APP_NAME/c\APP_NAME=\'$vagrant_name\'" /var/www/$folder_name/.env
sed -i "/APP_URL/c\APP_URL=http://$folder_name.local" /var/www/$folder_name/.env

sudo php artisan key:generate > /dev/null 2>&1

sed -i '/memory_limit/c\memory_limit = -1' /etc/php/$php_version/cli/php.ini
sed -i '/max_execution_time/c\max_execution_time = 0' /etc/php/$php_version/cli/php.ini

mysql -uroot -p1234 -e"CREATE DATABASE $folder_name;"

cp /var/www/$folder_name/setup/config/db_setup.sql /var/www/$folder_name/setup/config/db_setup_temp.sql
sed -i "s/db_user/$db_user/g" /var/www/$folder_name/setup/config/db_setup_temp.sql
sed -i "s/db_password/$db_password/g" /var/www/$folder_name/setup/config/db_setup_temp.sql

mysql -uroot -p1234 "mysql" < /var/www/$folder_name/setup/config/db_setup_temp.sql
rm /var/www/$folder_name/setup/config/db_setup_temp.sql

sudo perl -pi -w -e 's/bind-address/#bind-address/g;' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart > /dev/null 2>&1

/usr/bin/env $(which mailcatcher) --ip=0.0.0.0 > /dev/null 2>&1

now=$(date +"%T")
if [ ! -f /usr/bin/composer ]; then
    echo $'\n\033[33;33m '$now' ========> Installing Composer...'
    wget https://getcomposer.org/download/1.0.0-alpha11/composer.phar > /dev/null 2>&1
    mv composer.phar /usr/bin/composer
    sudo chmod +x /usr/bin/composer
else
    echo $'\n\033[33;33m '$now' ========> Composer installed... moving on'
fi

cp -r /var/www/$folder_name/setup/server-setup /home/vagrant/
cp -r /var/www/$folder_name/setup/server-setup/.zshrc /home/vagrant/.zshrc
cp -r /var/www/$folder_name/setup/scripts/.vimrc /home/vagrant/.vimrc

zsh=`dpkg -l | grep -i zsh`

now=$(date +"%T")
if [ "$zsh" = "" ]; then
    echo $'\n\033[33;33m '$now' ========> Installing ZSH...'

    sudo apt-get -qq install -y sshpass > /dev/null 2>&1
    sudo apt-get -qq install -y zsh > /dev/null 2>&1
    sudo perl -pi -w -e 's/bash/zsh/g' /etc/passwd
    git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh > /dev/null 2>&1
else
    echo $'\n\033[33;33m '$now' ========> ZSH installed... moving on'
fi

swapsize=4000
grep -q "swapfile" /etc/fstab
if [ $? -ne 0 ]; then
    echo $'\n\033[33;33m '$now' ========> Swapfile not found. Adding swapfile.n'
    fallocate -l ${swapsize}M /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap defaults 0 0' >> /etc/fstab
else
    echo $'\n\033[33;33m '$now' ========> Swapfile found... moving on'
fi

df -h
cat /proc/swaps
cat /proc/meminfo | grep Swap

now=$(date +"%T")
echo $'\n\033[33;33m '$now' ========> Vagrant has been setup successfully'
