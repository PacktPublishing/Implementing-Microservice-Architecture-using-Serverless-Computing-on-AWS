#!/usr/bin/env bash
#Variables
. ./common-variables.sh

aws cloudformation delete-stack --stack-name $template --region $region --profile $profile
