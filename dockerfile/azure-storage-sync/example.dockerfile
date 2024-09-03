FROM mcr.microsoft.com/azure-cli

RUN apk update && apk add --no-cache file && apk add coreutils
RUN apk add curl

RUN curl -L -o /home/azcp https://aka.ms/downloadazcopy-v10-linux
RUN tar -xvf /home/azcp -C /home
RUN cp /home/azcopy_linux_amd64_*/azcopy /usr/bin/

COPY container.food.blobsync.sh /home/blobsync.sh
COPY src.txt /home/src.txt

RUN chmod +x /home/blobsync.sh

CMD ["/bin/bash","-c","/home/blobsync.sh"]