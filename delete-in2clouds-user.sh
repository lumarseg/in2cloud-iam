#!/bin/bash


# Step 01: Get the account ID
account=$(aws sts get-caller-identity --query "Account" --output text)


# Step 02: Detach the policy from the group
aws iam detach-group-policy \
--group-name in2clouds \
--policy-arn arn:aws:iam::$account:policy/in2cloudsLambdaLeastPrivilege

aws iam detach-group-policy \
--group-name in2clouds \
--policy-arn arn:aws:iam::$account:policy/in2cloudsConnectLeastPrivilege

aws iam detach-group-policy \
--group-name in2clouds \
--policy-arn arn:aws:iam::$account:policy/in2cloudsDynamoDBLeastPrivilege

aws iam detach-group-policy \
--group-name in2clouds \
--policy-arn arn:aws:iam::$account:policy/in2cloudsCloudwatchLeastPrivilege


# Step 03: Delete the policy
aws iam delete-policy \
--policy-arn arn:aws:iam::$account:policy/in2cloudsLambdaLeastPrivilege

aws iam delete-policy \
--policy-arn arn:aws:iam::$account:policy/in2cloudsConnectLeastPrivilege

aws iam delete-policy \
--policy-arn arn:aws:iam::$account:policy/in2cloudsDynamoDBLeastPrivilege

aws iam delete-policy \
--policy-arn arn:aws:iam::$account:policy/in2cloudsCloudwatchLeastPrivilege


# Step 04: Delete the login profile
aws iam delete-login-profile --user-name dev.in2clouds


# Step 05: delete a user and group from AWS IAM.
aws iam remove-user-from-group --group-name in2clouds --user-name dev.in2clouds


# Step 06: Delete the "dev.in2clouds" user
aws iam delete-user --user-name dev.in2clouds


# Step 07: Delete the "in2clouds" group
aws iam delete-group --group-name in2clouds



echo
echo "Done, the user "dev.in2clouds" and group "in2clouds" has been deleted."
echo
