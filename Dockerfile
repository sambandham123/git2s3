FROM amazonlinux:latest

# Install the AWS CLI
RUN yum -y update && \
    yum -y install aws-cli && \
    yum -y clean all

# Install IAM Utils for role assumption
RUN yum -y install python3 

# Install Git 
RUN yum install git -y

RUN aws configure set aws_access_key_id AKIAQ6FRJAW6YWBOM5UT && \
    aws configure set aws_secret_access_key 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 && \
    aws configure set default.region ap-south-1 && \
    aws configure set default.output json


# Assume IAM Role and save credentials to a file
RUN aws sts assume-role --role-arn arn:aws:iam::064796296637:role/S3AdminRole --role-session-name docker-container > /tmp/assumed-role


# Set the working directory to /app
WORKDIR /app

# Download the GitRepo and upload text-file.txt to S3
RUN cd /app && \
    git clone https://github.com/sambandham123/git2s3.git && \
    cd git2s3 && \
    aws s3 cp text-file.txt s3://sambandham-tf-bucket/text-file.txt \
    --region ap-south-1 \