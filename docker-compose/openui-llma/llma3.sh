

lspci | grep -i NVIDIA
nvidia-smi

sudo apt-get remove --purge '^nvidia-.*''
sudo apt-get remove --purge '^libnvidia-.*'


# CONTAINER NVIDIA TOOLKIT
https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html




http://10.5.7.13:3000/


# check performance
watch -n 1 nvidia-smi

pip3 install --upgrade nvitop


ollama run llama3.1:70b