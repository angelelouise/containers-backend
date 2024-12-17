#!/bin/bash
echo -e "Creating resources"

BASE_PATH=/etc/localstack/init/ready.d

if [ -e "BASE_PATH/s3" ]; then
    bash $BASE_PATH/s3/s3.sh
fi