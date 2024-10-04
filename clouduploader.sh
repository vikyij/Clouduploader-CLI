#! /bin/bash

#Author: Victoria Udechukwu
#Created Date: 2/10/2024
#Updated: 4/10/2024

# This is a script to upload a specified file to a aws s3 bucket
# check if file exists before uploading
# add progress bar with pv
# Provide an option to generate and display a shareable link post-upload.
# Usage: ./clouduploader.sh

file_name=$1
bucket_name=$2
generate_link=$3
expiration_time=${4:-604800} #defaults to 604800s (7days) if no value is provided

# check if file exists

if [ -f "$file_name" ] 
 then 
  echo "$file_name found, proceeding to upload"
 else
  echo "Error: File not found"
 exit 1
fi

#upload file to aws s3 bucket
# upload_output=$(aws s3 cp "$file_name" s3://"$bucket_name"/ 2>&1)

#pv to monitor progress
upload_output=$(pv "$file_name" | aws s3 cp - s3://"$bucket_name"/"$file_name")

upload_status=$?

if [ $upload_status -eq 0 ]
 then 
  echo "File uploaded successfully!"
  if [ "$generate_link" = true ]
  then
   presign_url=$(aws s3 presign s3://"$bucket_name"/"$file_name" --expires-in "$expiration_time")
  echo "Click link to preview: $presign_url"
fi
 else
  echo "Upload Failed: $upload_output"
 exit 2
fi


