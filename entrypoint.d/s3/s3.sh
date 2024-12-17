#!/bin/bash

create_buckets(){
    for BUCKET_FILE in "${BUCKET_FILES[@]}"; do
        echo - e "Creating bucket [$BUCKET_FILE]"
        awslocal s3api create-bucket --cli-input-json file://"$BUCKET_FILE" >> /dev/null
    done

    echo -e "Created buckets: "
    awslocal s3api list-buckets
}

BASE_PATH=/etc/localstack/init/ready.d
BUCKET_FILES=("$BASE_PATH"/s3/buckets/*.json)

if [ -e "${BUCKET_FILES[0]}" ]; then
    echo -e "Creating s3 buckets"
    create_buckets
else
    echo -e "s3 buckets script not found"
fi