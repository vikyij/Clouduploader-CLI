#! /bin/bash

#Author: Victoria Udechukwu
#Created Date: 2/10/2024
#Updated: 2/10/2024

# This is a script to upload a specified file to a aws s3 bucket
# Usage: ./clouduploader.sh

file_name=$1
bucket_name=$2

# check if file exists

if [ -f "$file_name" ] 
 then 
  echo "$file_name found, proceeding to upload"
 else
  echo "Error: File not found"
 exit 1
fi

#upload file to aws s3 bucket
upload_output=$(aws s3 cp "$file_name" s3://"$bucket_name"/ 2>&1)
upload_status=$?

if [ $upload_status -eq 0 ]
 then 
  echo "File uploaded successfully!"
 else
  echo "Upload Failed: $upload_output"
 exit 2
fi
