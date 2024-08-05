#!/bin/bash
cd /home
app_id=""
tenant=""
sourceurl="https://<>.blob.core.windows.net"
destinationurl="https://<>.blob.core.windows.net"

pemfile="/home/service-principal.pem"

sourceaccount=$(echo $sourceurl | awk -F/ '{print $3}' | awk -F. '{print $1}')
destinationaccount=$(echo $destinationurl | awk -F/ '{print $3}' | awk -F. '{print $1}')

echo $app_id
echo $tenant
echo $sourceurl
echo $destinationurl

echo $sourceaccount
echo $destinationaccount

az login --service-principal --password $pemfile --username $app_id --tenant $tenant

# list storage containers
az storage container list --auth-mode login --account-name $sourceaccount -o=table | awk 'NR>1 {print $1}' | grep networking-guru > src.txt
az storage container list --auth-mode login --account-name $destinationaccount -o=table | awk 'NR>1 {print $1}' | grep networking-guru > dst.txt

grep -vf dst.txt src.txt > diff.txt 

for blob_container in $(cat diff.txt);
        do
        echo $blob_container;
        newcmd="az storage container create --auth-mode login --account-name $destinationaccount -n $blob_container --fail-on-exist" 
        echo "---------------------------------"
        echo $newcmd
        eval $newcmd
done

echo "performing AZCOPY login"
azcopy login --service-principal --certificate-path $pemfile --application-id $app_id --tenant-id $tenant



echo "performing AZCOPY sync for each container"
for blob_container in $(cat src.txt);
   do
    #Create timestame + 30 Minutes for SAS token
    end=`date -u -d "30 minutes" '+%Y-%m-%dT%H:%MZ'`
    sourcesas=`az storage container generate-sas --account-name $sourceaccount --as-user --auth-mode login --name $blob_container --expiry $end --permissions acdlrw`
    echo $sourcesas
    # remove leading and trailing quotes from SAS Token
    sourcesas=$(eval echo $sourcesas)
    echo $sourcesas
    src="$sourceurl/$blob_container?$sourcesas"
    dst="$destinationurl/$blob_container"
    echo $src
    echo $dst
    synccmd="azcopy sync \"$src\" \"$dst\" --recursive --delete-destination=true"
    echo $synccmd
    eval $synccmd
done