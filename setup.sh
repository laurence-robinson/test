#/bin/bash

#Setup Git
echo "Setting up Git..."
mkdir ~/.ssh
cd ~/.ssh
touch id_rsa
touch id_rsa.pub
vi id_rsa
vi id_rsa.pub
chmod 400 id_rsa

cd ~

mkdir ~/.git
touch ~/.git/config
echo "Enter your Git username: "
read username
git config --add user.name $username
echo "Enter your Git email: "
read email
git config --add user.email $email
git clone git@github.com:riotgameseurope/rgts.git

cd ~/rgts

touch config/application.yml
vi config/application.yml

curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

cd ~/rgts

docker-compose build
docker-compose run app bundle install --path /remote_gems --without test
docker-compose run app bundle exec rake assets:precompile
docker-compose run app bundle exec rake db:create db:migrate
docker-compose run app bundle exec rake db:seed
docker-compose up
