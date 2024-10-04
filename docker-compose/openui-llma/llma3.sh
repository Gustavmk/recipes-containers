# Run LLMA3
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

# Run OpenApi Web
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main



lspci | grep -i NVIDIA
nvidia-smi

sudo apt update && sudo apt install -y ubuntu-drivers-common
sudo ubuntu-drivers install

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo apt install -y ./cuda-keyring_1.1-1_all.deb
sudo apt update
sudo apt install cuda-toolkit-12-5
sudo apt-get install -y nvidia-container-toolkit

sudo apt-get remove --purge '^nvidia-.*''
sudo apt-get remove --purge '^libnvidia-.*'


sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update

sudo apt-get install nvidia-driver-525 -y 

sudo reboot

nvidia-smi   

# CONTAINER NVIDIA TOOLKIT
https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
nvidia-ctk runtime configure --runtime=docker --config=$HOME/.config/docker/daemon.json
systemctl --user restart docker
sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi


http://10.5.7.13:3000/


# check performance
watch -n 1 nvidia-smi

pip3 install --upgrade nvitop