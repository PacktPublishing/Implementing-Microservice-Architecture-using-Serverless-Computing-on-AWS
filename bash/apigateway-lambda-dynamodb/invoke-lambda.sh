#!/bin/sh
status_code=$(aws lambda invoke --invocation-type Event --function-name lambda-dynamo-data-api-sam --region eu-west-1 --region eu-west-1 --payload file://../../sample_data/request-api-gateway-valid-get.json outputfile.tmp)
echo "$status_code"
if echo "$status_code" | grep -q "202";
then 
    echo "pass"
    exit 0
else 
    exit 1
fi