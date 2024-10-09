#! /bin/bash

#Author: Victoria Udechukwu
#Created Date: 2/10/2024
#Updated: 9/10/2024

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

#check if file already exist in aws
#aws s3api head-object --bucket "$bucket_name" --key "$file_name" || NOT_EXIST=true
aws s3 ls s3://"$bucket_name"/"$file_name" 2>&1

if [ $? -eq 0 ]; then
 echo "The file $file_name already exists in the bucket $bucket_name"
 echo "Choose an action (O)verride, (S)kip, (R)ename"

 read -p "Enter your Choice(O,S,R): " choice

 case "$choice" in
    O|o)
      echo "Overwriting file..."
      $(pv "$file_name" | aws s3 cp - s3://"$bucket_name"/"$file_name") 
      upload_status=$?
      ;;
    S|s)
     echo "Skipping upload..."
     exit 2 ;;
    R|r)
     read -p "Enter a new name for the file: " new_file_name
     $(pv "$file_name" | aws s3 cp - s3://"$bucket_name"/"$new_file_name")
     upload_status=$?
     ;;
    *)
     echo "Invalid option selected. Exiting..."
     exit 3 ;;
esac
     
else   
#upload file to aws s3 bucket
#pv to monitor progress
# upload_output=$(aws s3 cp "$file_name" s3://"$bucket_name"/ 2>&1)
upload_output=$(pv "$file_name" | aws s3 cp -  s3://"$bucket_name"/"$file_name")
upload_status=$?
fi


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
 exit 4
fi


