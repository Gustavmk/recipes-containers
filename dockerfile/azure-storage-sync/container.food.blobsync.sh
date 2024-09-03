#!/bin/bash
cd /home
#pemfile="/home/service-principal.pem"
#app_id=""
tenant="tenant id"
sourceurl="https://.blob.core.windows.net"
destinationurl="https://.blob.core.windows.net"

#az login --service-principal --password $pemfile --username $app_id --tenant $tenant

sourceaccount=$(echo $sourceurl | awk -F/ '{print $3}' | awk -F. '{print $1}')
destinationaccount=$(echo $destinationurl | awk -F/ '{print $3}' | awk -F. '{print $1}')

echo $app_id
echo $tenant
echo $sourceurl
echo $destinationurl

echo $sourceaccount
echo $destinationaccount


SRC_KEY=''
DEST_KEY=''
# list storage containers
SOURCE_CONNECTION_STRING="DefaultEndpointsProtocol=https;AccountName=$sourceaccount;AccountKey=$SRC_KEY;EndpointSuffix=core.windows.net"
DESTINATION_CONNECTION_STRING="DefaultEndpointsProtocol=https;AccountName=$destinationaccount;AccountKey=$DEST_KEY;EndpointSuffix=core.windows.net"


echo "performing AZCOPY sync for each container"
log_name='log5'
for blob_container in $(cat src.txt);
#for blob_container in $(cat reshop-blobs-essenciais.txt);
   do
    #Create timestame + 60 Minutes for SAS token
    end=`date -u -d "24 hours" '+%Y-%m-%dT%H:%MZ'`
    sourcesas=`az storage container generate-sas --account-name $sourceaccount --auth-mode key --name $blob_container --expiry $end --permissions acdlrw --connection-string $SOURCE_CONNECTION_STRING`
    destinationsas=`az storage container generate-sas --account-name $destinationaccount --auth-mode key --name $blob_container --expiry $end --permissions acdlrw --connection-string $DESTINATION_CONNECTION_STRING`
    echo $sourcesas
    # remove leading and trailing quotes from SAS Token
    sourcesas=$(eval echo $sourcesas)
    destinationsas=$(eval echo $destinationsas)
    echo "Source SAS: ${sourcesas}"
    echo "Destination SAS: ${destinationsas}"
    src="$sourceurl/$blob_container?$sourcesas"
    dst="$destinationurl/$blob_container?$destinationsas"
    echo $src >> "${destinationaccount}_${blob_container}_${log_name}.txt"
    echo $dst >> "${destinationaccount}_${blob_container}_${log_name}.txt"
    synccmd="azcopy copy \"$src\" \"$dst\" --recursive --overwrite=ifSourceNewer --log-level=WARNING --check-length=false >> ${destinationaccount}_${blob_container}_${log_name}.txt"
    echo $synccmd
    eval $synccmd
done
