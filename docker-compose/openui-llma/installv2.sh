# after install extension

apt update && apt install nvidia-cuda-toolkit -y 
sudo reboot

# check with 
nvidia-smi && nvcc --version

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update

sudo apt-get install -y nvidia-container-toolkit

sudo nvidia-ctk runtime configure --runtime=docker
nvidia-ctk runtime configure --runtime=docker --config=$HOME/.config/docker/daemon.json
sudo systemctl restart docker

# Test nvidia-smi with the latest official CUDA image
sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
