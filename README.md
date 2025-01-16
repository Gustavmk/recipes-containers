# recipes-containers

Install docker

```bash
apt install curl -y  && curl -fsSL https://get.docker.com -o get-docker.sh | sudo sh get-docker.sh

sudo groupadd docker
sudo usermod -aG docker $USER
mkdir -p ~/.docker
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R

sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

# Windows with WSL

```bash
lsb_release -a # check linux version

curl -fsSL https://get.docker.com -o get-docker.sh 
sudo sh get-docker.sh   

# sudo hwclock --hctosys # just in case of clock being out-f-sync between Windows machine an Ubuntu running in WSL2
# after runned command above do wsl --shutdown 
sudo usermod -aG docker $USER

newgrp docker

# test
docker run hello-world

sudo systemctl enable docker.service
```