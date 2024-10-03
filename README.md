# Objective

This project aims to create a bash-based Command-Line Interface (CLI) tool for efficiently uploading files to AWS S3. Designed for simplicity and ease of use, it allows users to quickly transfer files to AWS S3.

## Prerequisite

- Basic understanding of Linux commands.
- Familiarity with Bash scripting.
- Knowledge of a text editor (Nano, Vi, Vim, etc.). This guide uses Vim.
- A terminal running Bash.
- Basic understanding of AWS S3.

Before using CloudUploader, ensure you have the following:

- AWS CLI installed and configured with your AWS credentials.(https://aws.amazon.com/cli/)
- Basic familiarity with command-line operations. (https://www.codecademy.com/article/command-line-commands)

## Test Connection:

Run the command below:
``` aws --version ```
The version of aws installed will be displayed if installed correctly.

## Create the S3 Bucket

- Create bucket
  ``` aws s3 mb s3://unique-bucket-name ```

## Create the Script File with Executable Permissions

- Create the script file and give executable permission:

```
  touch clouduploader.sh
  chmod 744 clouduploader.sh
```

## Write the script using Vim:

``` vim clouduploader.sh```

### Script Explanation

- Defining Variables:** file_name and bucket_name capture the first and second command-line arguments, respectively.

- Checking File Existence:** Validates the presence of the specified file before attempting upload.

- Performing File Upload:** Utilizes aws s3 cp to upload the file, capturing output and status for error handling.

- Success and Error Reporting:** Provides clear feedback on the upload process's outcome.

## Execute the Script

Run the script with the file and bucket name as arguments:
``` ./clouduploader.sh file.txt unique-bucket-name```

To verify the upload:
``` aws s3 ls s3://unique-bucket-name```
