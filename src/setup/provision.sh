#!/bin/bash

folder_name=$1
vagrant_ip=$2
db_user=$3
db_password=$4
vagrant_name=$5

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'

pwd=`pwd`
home="/home/vagrant/${folder_name}"

function echo_msg()
{
    NC='\033[0m'
    now=$(date +"%T")
    printf "\n$1${now} ========> $2...${NC} "
}

echo_msg ${GREEN} "The provisioning process will take about 5-10 minutes"
sudo usermod -a -G www-data vagrant

echo_msg ${GREEN} "Provisioning virtual machine"

phppresent=`which php`
if [[ "$phppresent" = "" ]]; then
    echo_msg ${GREEN} "Updating os"
    sudo apt update -y > /dev/null 2>&1

    echo_msg ${GREEN} "Upgrading os"
    sudo apt upgrade -y > /dev/null 2>&1

    echo_msg ${GREEN} "Installing php 7.2"
    sudo apt install -y php > /dev/null 2>&1

    echo_msg ${GREEN} "Installing php packages"
    sudo install -y build-essential tcl libsqlite3-dev ruby-dev > /dev/null 2>&1
    echo postfix postfix/mailname string ${home} | sudo debconf-set-selections
    echo postfix postfix/main_mailer_type string 'Internet Site' | sudo debconf-set-selections
    echo "mysql-server-5.7 mysql-server/root_password password $db_password" | sudo debconf-set-selections
    echo "mysql-server-5.7 mysql-server/root_password_again password $db_password" | sudo debconf-set-selections
    sudo apt install -y php-common php-dev php-cli php-fpm curl php-curl php-gd mcrypt php-mysql php-imap php-mbstring php-zip nginx php-bcmath php-xml chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev redis-server php-redis postfix sshpass zsh php-xdebug mysql-server-5.7 build-essential libsqlite3-dev ruby-dev ruby php-sqlite3 > /dev/null 2>&1

    echo_msg ${GREEN} "Removing apache"
    sudo apt remove -y apache2 > /dev/null 2>&1

    echo_msg ${GREEN} "Cleaning up after package install"
    sudo apt autoremove -y > /dev/null 2>&1
    sudo apt-add-repository ppa:brightbox/ruby-ng-experimental -y > /dev/null 2>&1
    sudo apt update -y > /dev/null 2>&1
    sudo sed -i '/memory_limit/c\memory_limit = -1' /etc/php/7.2/cli/php.ini
    sudo sed -i '/max_execution_time/c\max_execution_time = 0' /etc/php/7.2/cli/php.ini
    sudo cp ${home}/setup/config/xdebug.ini /etc/php/7.2/mods-available/withxdebug.ini
    sudo cp ${home}/setup/config/noxdebug.ini /etc/php/7.2/mods-available/withoutxdebug.ini

    echo_msg ${GREEN} "Configuring redis"
    sudo systemctl enable redis-server.service > /dev/null 2>&1
    sudo sed -i '/bind*/c\bind 0.0.0.0' /etc/redis/redis.conf
    sudo sed -i '/timeout 0/c\#timeout 0' /etc/redis/redis.conf
    sudo service redis-server restart > /dev/null 2>&1
fi

if [[ ! -e /etc/default/phantomjs ]]; then
    echo_msg ${GREEN} "Installing phantomjs"
    export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64" > /dev/null 2>&1
    wget https://github.com/Medium/phantomjs/releases/download/v2.1.1/${PHANTOM_JS}.tar.bz2 > /dev/null 2>&1
    sudo tar xvjf ${PHANTOM_JS}.tar.bz2 > /dev/null 2>&1
    sudo mv ${PHANTOM_JS} /usr/local/share > /dev/null 2>&1
    sudo ln -sf /usr/local/share/${PHANTOM_JS}/bin/phantomjs /usr/local/bin > /dev/null 2>&1
    sudo touch /etc/default/phantomjs > /dev/null 2>&1
    echo "WEBDRIVER_PORT=4444" > sudo /etc/default/phantomjs
fi

phpmailcatcher=`which mailcatcher`
if [[ "$phpmailcatcher" = "" ]]; then
    echo_msg ${GREEN} "Installing mailcatcher"
    sudo service postfix reload > /dev/null 2>&1
    sudo gem install mailcatcher --no-ri --no-rdoc > /dev/null 2>&1
    echo "@reboot root $(which mailcatcher) --ip=0.0.0.0" >> sudo /etc/crontab
    sudo update-rc.d cron defaults > /dev/null 2>&1
    sudo touch /etc/php/7.2/mods-available/mailcatcher.ini
    echo "sendmail_path = /usr/bin/env $(which catchmail) -f 'www-data@localhost'" >> sudo /etc/php/7.2/mods-available/mailcatcher.ini
    sudo phpenmod -v ALL -s ALL mailcatcher
    sudo cp ${home}/setup/mailcatcher.conf /etc/init/mailcatcher.conf > /dev/null 2>&1
    sudo service php7.2-fpm restart > /dev/null 2>&1
    /usr/bin/env $(which mailcatcher) --ip=0.0.0.0 > /dev/null 2>&1
    echo '@reboot root $(which mailcatcher) --ip=0.0.0.0' >> sudo /etc/crontab > /dev/null 2>&1
    sudo update-rc.d cron defaults > /dev/null 2>&1
fi

phpcomposer=`which composer`
if [[ "$phpcomposer" = "" ]]; then
    echo_msg ${GREEN} "Installing composer"
    wget https://getcomposer.org/download/1.0.0-alpha11/composer.phar > /dev/null 2>&1
    sudo mv composer.phar /usr/bin/composer
    sudo chmod +x /usr/bin/composer
    echo "y" | sudo ufw enable > /dev/null 2>&1
    sudo ufw allow "Nginx Full" > /dev/null 2>&1
    sudo ufw allow "OpenSSH" > /dev/null 2>&1
    sudo ufw allow "3306" > /dev/null 2>&1
    sudo ufw allow "6379" > /dev/null 2>&1
    sudo ufw allow "1025" > /dev/null 2>&1
    sudo ufw allow "1080" > /dev/null 2>&1
    sudo ufw allow "4444" > /dev/null 2>&1
fi

sudo cp ${home}/setup/config/hosts /etc/hosts
sudo sed -i "s/folder_name/${folder_name}/g" /etc/hosts
sudo sed -i "s/vagrant_ip/${vagrant_ip}/g" /etc/hosts

function loadEnv()
{
    cp ${home}/setup/config/example.env${1} ${home}/.env${1}
    sed -i "s/folder_name/$folder_name/g" ${home}/.env${1}
    sed -i "s/vagrant_ip/$vagrant_ip/g" ${home}/.env${1}
    sed -i "s/db_user/$db_user/g" ${home}/.env${1}
    sed -i "s/db_password/$db_password/g" ${home}/.env${1}
    sed -i "/APP_NAME/c\APP_NAME=\'$vagrant_name\'" ${home}/.env${1}
    sed -i "/APP_URL/c\APP_URL=http://$folder_name.local" ${home}/.env${1}
}

sudo chmod -R o+w ${home}/storage

echo_msg ${GREEN} "Configuring application"

cp ${home}/setup/config/db_setup.sql ${home}/setup/config/db_setup_temp.sql
sed -i "s/db_user/$db_user/g" ${home}/setup/config/db_setup_temp.sql
sed -i "s/db_password/$db_password/g" ${home}/setup/config/db_setup_temp.sql

mysql -uroot -p"$db_password" "mysql" < ${home}/setup/config/db_setup_temp.sql > /dev/null 2>&1
rm ${home}/setup/config/db_setup_temp.sql

sudo perl -pi -w -e 's/bind-address/#bind-address/g;' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart > /dev/null 2>&1

cd ${home}

composer install > /dev/null 2>&1

loadEnv
php artisan key:generate > /dev/null 2>&1
echo 'yes' | php artisan jwt:secret > /dev/null 2>&1
php artisan cache:clear > /dev/null 2>&1
php artisan config:clear > /dev/null 2>&1

cd ${pwd}

if [[ ! -e /home/vagrant/.zshrc ]]; then
    echo_msg ${GREEN} "Installing zsh"
    cp -r ${home}/setup/server-setup /home/vagrant/
    cp -r ${home}/setup/server-setup/.zshrc /home/vagrant/.zshrc
    cp -r ${home}/setup/scripts/.vimrc /home/vagrant/.vimrc
    sudo chown vagrant.vagrant /home/vagrant/.zshrc
    git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh > /dev/null 2>&1
    sudo perl -pi -w -e 's/bash/zsh/g' /etc/passwd
fi

if [[ ! -e /etc/nginx/sites-available/${folder_name} ]]; then
    echo_msg ${GREEN} "Configuring nginx"
    sudo cp ${home}/setup/config/generic_vhost /etc/nginx/sites-available/${folder_name}
    sudo sed -i "s/site_name/${folder_name}.local/g" /etc/nginx/sites-available/${folder_name}
    sudo sed -i "s/folder_name/${folder_name}/g" /etc/nginx/sites-available/${folder_name}
    sudo sed -i "s/php_version/7.2/g" /etc/nginx/sites-available/${folder_name}
    sudo ln -s /etc/nginx/sites-available/${folder_name} /etc/nginx/sites-enabled/
    sudo rm -rf /etc/nginx/sites-available/default
    sudo rm /etc/nginx/sites-enabled/default
    service nginx restart > /dev/null 2>&1
fi

echo_msg ${GREEN} "Configuring google chromedriver"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - > /dev/null 2>&1
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt update -y && sudo apt install -y google-chrome-stable xvfb > /dev/null 2>&1
