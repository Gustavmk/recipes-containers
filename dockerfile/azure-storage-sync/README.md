# recipes-containers


Create certifcate info
Credit: https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_certificate.html

```bash
# Create private key
openssl req -newkey rsa:4096 -nodes -keyout "service-principal.key" -out "service-principal.csr"
Sign and Create crt for App ID 
openssl x509 -signkey "service-principal.key" -in "service-principal.csr" -req -days 365 -out "service-principal.crt"

# Create pem file for usage
openssl pkcs12 -export -out "service-principal.pfx" -inkey "service-principal.key" -in "service-principal.crt"
openssl pkcs12 -in service-principal.pfx -out service-principal.pem -nodes


# Docker Commands (using docker desktop)
docker build --tag yt-blobsync:latest .
docker run interactice - remmeber to remove CMD from Dockerfile
docker run  -it yt-blobsync:latest
# Security fix
docker run --security-opt="seccomp:unconfined" -it yt-blobsync:latest

# Just run non interactive
docker run --security-opt="seccomp:unconfined" yt-blobsync:latest

# My Example

docker build --tag example-blob-sync:v2 -f example.dockerfile .   
docker login name_of_acr.azurecr.io
docker image tag example-blob-sync:v3 name_of_acr.azurecr.io/cloud/example-blob-sync:v3
docker image push name_of_acr.azurecr.io/cloud/example-blob-sync:v3
```
