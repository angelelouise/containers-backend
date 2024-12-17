#!/bin/bash

create_buckets(){
    for BUCKET_FILE in "${BUCKET_FILES[@]}"; do
        echo - e "Creating bucket [$BUCKET_FILE]"
        awslocal s3api create-bucket --cli-input-json file://"$BUCKET_FILE" >> /dev/null
    done

    echo -e "Created buckets: "
    awslocal s3api list-buckets
}

create_files(){
    for FILE in "${FILES[@]}"; do
        BUCKET_NAME=$(awslocal s3api list-buckets --query "Buckets[].Name" --output text)
        echo - e "Copying file [$FILE] to s3 bucket [$BUCKET_FILE]"
        awslocal s3 cp $FILE s3://$BUCKET_NAME >> /dev/null
    done
}

BASE_PATH=/etc/localstack/init/ready.d
BUCKET_FILES=("$BASE_PATH"/s3/buckets/*.json)
FILES=("$BASE_PATH"/s3/files/*)

if [ -e "${BUCKET_FILES[0]}" ]; then
    echo -e "Creating s3 buckets"
    create_buckets
else
    echo -e "s3 buckets script not found"
fi

if [ -e "${FILES[0]}" ]; then
    echo -e "Creating s3 init files"
    create_files
else
    echo -e "s3 files script not found"
fi