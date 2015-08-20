# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

echo updating package information
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1
apt-get -y update >/dev/null 2>&1

install 'development tools' build-essential

# Ruby
install Ruby ruby2.2 ruby2.2-dev
update-alternatives --set ruby /usr/bin/ruby2.2 >/dev/null 2>&1
update-alternatives --set gem /usr/bin/gem2.2 >/dev/null 2>&1

# Bundler
echo installing Bundler
gem install bundler -N >/dev/null 2>&1

# SQLite
install SQLite sqlite3 libsqlite3-dev
install 'ExecJS runtime' nodejs

# git
#install Git git

# memcache
#install memcached memcached

# Redis
#install Redis redis-server

#RabbitMQ
#install RabbitMQ rabbitmq-server

# PostgreSQL
#install PostgreSQL postgresql postgresql-contrib libpq-dev
#sudo -u postgres createuser --superuser vagrant
#sudo -u postgres createdb -O vagrant activerecord_unittest
#sudo -u postgres createdb -O vagrant activerecord_unittest2

# MYSQL
#debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
#debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
#install MySQL mysql-server libmysqlclient-dev
#mysql -uroot -proot <<SQL
#CREATE USER 'rails'@'localhost';
#CREATE DATABASE activerecord_unittest  DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
#CREATE DATABASE activerecord_unittest2 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
#GRANT ALL PRIVILEGES ON activerecord_unittest.* to 'rails'@'localhost';
#GRANT ALL PRIVILEGES ON activerecord_unittest2.* to 'rails'@'localhost';
#GRANT ALL PRIVILEGES ON inexistent_activerecord_unittest.* to 'rails'@'localhost';
#SQL

# libxml
#install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev

# Needed for docs generation.
#update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo 'Initial vagrant up completed!'
