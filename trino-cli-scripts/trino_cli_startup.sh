#!/bin/bash
yum update 
yum install wget -y
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
mv mc /usr/bin/mc
mc alias set minio http://gke-bucket-minio.default.svc.cluster.local:9000 $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY
tail -f /dev/null
