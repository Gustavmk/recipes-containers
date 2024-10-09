# recipes-containers

Install docker

apt install curl -y  && curl -fsSL https://get.docker.com -o get-docker.sh | sudo sh get-docker.sh

sudo groupadd docker
sudo usermod -aG docker $USER
mkdir -p ~/.docker
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R

sudo systemctl enable docker.service
sudo systemctl enable containerd.service


sudo mkdir /usr/local/lib/docker/
sudo curl -SL https://github.com/docker/compose/releases/download/v2.29.6/docker-compose-linux-x86_64 -o /usr/local/lib/docker/docker-compose
sudo chmod +x /usr/local/lib/docker/docker-compose
sudo ln -s /usr/local/lib/docker/docker-compose /usr/local/bin
docker-compose -v