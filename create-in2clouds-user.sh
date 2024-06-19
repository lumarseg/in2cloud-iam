#!/bin/bash


# Step 01: Get the account ID
account=$(aws sts get-caller-identity --query "Account" --output text)


# Step 02: Create the "dev.in2clouds" user
aws iam create-user --user-name dev.in2clouds


# Step 03: Create the "in2clouds" group
aws iam create-group --group-name in2clouds


# Step 04: Add the user to the group
aws iam add-user-to-group --user-name dev.in2clouds --group-name in2clouds


# Step 05: Generate a random password for the "dev.in2clouds" user
password=$(aws secretsmanager get-random-password --password-length 16 --exclude-characters '"@/\[]{}()~;,.|`' --output text)


# Step 06: Enable console access for the "dev.in2clouds" user
aws iam create-login-profile --user-name dev.in2clouds --password "$password" --password-reset-required


# Step 07: Create a policy for minimum privileges for Lambda
aws iam create-policy \
--policy-name in2cloudsLambdaLeastPrivilege \
--policy-document '{
    "Version":"2012-10-17",
    "Statement":[
        {
        "Action":[
            "lambda:CreateFunction",
            "lambda:DeleteFunction",
            "lambda:GetFunction",
            "lambda:InvokeFunction",
            "lambda:ListFunctions",
            "lambda:UpdateFunctionCode",
            "lambda:UpdateFunctionConfiguration"],
        "Effect":"Allow",
        "Resource":"*"
        }
    ]
}'


# Step 08: Create a policy for minimum privileges for Amazon Connect
aws iam create-policy \
--policy-name in2cloudsConnectLeastPrivilege \
--policy-document '{
    "Version":"2012-10-17",
    "Statement":[
        {
        "Action":"connect:CreateInstance",
        "Effect":"Allow",
        "Resource":"*"
        }
    ]
}'


# Step 09: Create a policy for creating tables in DynamoDB
aws iam create-policy \
--policy-name in2cloudsDynamoDBLeastPrivilege \
--policy-document '{
    "Version":"2012-10-17",
    "Statement":[
        {
        "Action":[
            "dynamodb:CreateTable",
            "dynamodb:DescribeTable",
            "dynamodb:ListTables"],
        "Effect":"Allow",
        "Resource":"*"
        }
    ]
}'


# Step 10: Attach the policies to the "in2clouds" group
aws iam attach-group-policy \
--group-name in2clouds \
--policy-arn arn:aws:iam::$account:policy/in2cloudsLambdaLeastPrivilege

aws iam attach-group-policy \
--group-name in2clouds \
--policy-arn arn:aws:iam::$account:policy/in2cloudsConnectLeastPrivilege

aws iam attach-group-policy \
--group-name in2clouds \
--policy-arn arn:aws:iam::$account:policy/in2cloudsDynamoDBLeastPrivilege



echo
echo "The 'dev.in2clouds' user has been created successfully."
echo "The temporary password is: $password"
echo "URL: https://$account.signin.aws.amazon.com/console"
echo
echo "done !!!"
echo