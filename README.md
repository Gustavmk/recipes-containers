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

