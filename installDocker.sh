#Install Docker
wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker $(whoami)
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo yum install -y epel-release
sudo yum install -y python-pip
/usr/bin/yes | sudo pip install docker-compose
sudo yum upgrade python*

docker-compose build
docker-compose run app bundle install --path /remote_gems --without test
docker-compose run app bundle exec rake assets:precompile
docker-compose run app bundle exec rake db:create db:migrate
docker-compose run app bundle exec rake db:seed
docker-compose up
