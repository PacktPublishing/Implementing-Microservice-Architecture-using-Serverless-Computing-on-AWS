Copyright (c) 2017-2018 Starwolf Ltd and Richard Freeman. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License").
You may not use this file except in compliance with the License.
A copy of the License is located at http://www.apache.org/licenses/LICENSE-2.0 or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


## Implementing Serverless Microservices Architecture Patterns [Video]

In this repository, I share parts of my source code from my two Serverless video courses, specifically implementing a scalable Serverless data API using API Gateway, Lambda and DynamoDB. This repository includes full bash scripts that can be used to unit test, build, package, deploy, and run integration tests. The Python code is written defensively to deal with any API exception and I've included code to insert records from a file into DynamoDB as well as code to query it efficiently.

Additional implemented Serverless pattern architecture, source code, shell scripts, config and walkthroughs are provided with my video courses:


|For beginners and intermediates, the [full Serverless Data API](https://www.packtpub.com/application-development/building-scalable-serverless-microservice-rest-data-api-video?utm_source=github&utm_medium=repository&utm_campaign=9781788839570) code, configuration and a detailed walk through |For intermediate or advanced users, I cover the implementation of [15+ serverless microservice patterns](https://www.packtpub.com/application-development/implementing-serverless-microservices-architecture-patterns-video?utm_source=github&utm_medium=repository&utm_campaign=9781788839570) with original content, code, configuration and detailed walk through |
|:----------|:-------------|
| [![Building a Scalable Serverless Microservice REST Data API Video Course](images/building-scalable-serverless-microservice-rest-data-api-video.png "Building a Scalable Serverless Microservice REST Data API Video Course")](https://www.packtpub.com/application-development/building-scalable-serverless-microservice-rest-data-api-video)|  [![Implementing Serverless Microservices Architecture Patterns Video Course](./images/implementing-serverless-microservices-architecture-patterns-video.png "Implementing Serverless Microservices Architecture Patterns Video Course")](https://www.packtpub.com/application-development/implementing-serverless-microservices-architecture-patterns-video) |



### 1. Windows Only

A lot can be done with the web interface in the AWS Management console, but most often that is time consuming, repetitive and prone to error, and not recommended for production deployments. What is accepted as best practice is to deploy and manage your infrastructure using code and configuration only.

Using bash makes your life much easier when deploying and managing you serverless stack. I think all analysts, data scientists, architects, administrators, DBAs, developers, DevOps and technical people should know some basic bash and be able to run shell scripts, which are typically used on LINUX and UNIX (including macOS Terminal).

Alternatively you can adapt the scripts to use MS-DOS or Powershell but it's not something I recommended given that bash can now run natively on Windows 10+ as a feature.

Install Bash for Windows:

* Control Panel > Programs > Turn Windows Features On Or Off. 
* Enable the `Windows Subsystem for Linux` option in the list, and then click the `OK` button.
* Select Ubuntu
* [Detailed guide](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/)

### 2. Update Ubuntu, Install Git and Clone Repository
```
$ sudo apt-get update
$ sudo apt-get -y upgrade
$ apt-get install git-core
$ mkdir ~/git
$ cd ~/git
$ git clone https://github.com/PacktPublishing/Implementing-Microservice-Architecture-using-Serverless-Computing-on-AWS
```

### 3. Install Python and Dependencies

The Lambda code uses Python. Pip is a tool for installing and managing Python packages. The packages required for the severless data API are listed in  `requirements.txt` and can be installed using pip

```
$ apt-get -y install python2.7 python-pip
$ cd Implementing-Microservice-Architecture-using-Serverless-Computing-on-AWS/serverless.microservice.data.api
$ sudo pip install -r requirements.txt
```

### 3. Install and Setup AWS CLI

You will need to create a user, AWS keys, and enter them them running aws configure. more details are available in [AWS Docs](https://docs.aws.amazon.com/lambda/latest/dg/setup-awscli.html) or my courses.

```
$ pip install awscli --upgrade --user
$ aws configure
```

### 4. Update AccountId, Bucket and Profile
Here I assume your AWS profile is `demo` you can change that under `serverless.microservice.data.api/bash/apigateway-lambda-dynamodb/common-variables.sh`. 
You will need to use a bucket or create one if you haven't already:
```
$ aws s3api create-bucket --bucket mynewbucket231 --profile demo --create-bucket-configuration Loc
ationConstraint=eu-west-1 --region eu-west-1

```
You will also need to change the AWS accountId (current set to 000000000000). The AWS accountId is also used in some IAM policies in the IAM folder. In addition the region will have to be changed.

to replace your accountId (assume your AWS accountId is 111111111111) you can do it manually or run:
```
find ./ -type f -exec sed -i '' -e 's/000000000000/111111111111/' {} \;
```

### 5. Run Unit Tests
Change directory to the main bash folder
```
$ cd bash/apigateway-lambda-dynamodb/
$ ./unit-test-lambda.sh
```

### 6. Build Package and Deploy the Serverless API
This also creates the IAM Polices and IAM Roles using the AWS CLI that will be required for the Lambda function.
```
$ ./build-package-deploy-lambda-dynamo-data-api.sh
```
In less than a minute you should have a stack. Otherwise look at the error messages, CloudFormation stack and ensure your credentials are setup correctly.

### 7. Run Lambda Integration Test
Once the stack is up and running, you can run an integration test to check that the Lambda is working.
```
./invoke-lambda.sh
```

### 8. Add data to DynamoDb table

Change to the DynamoDB Python directory and run the Python code, you can also run this under you favourite IDE like PyDev or PyCharm.
```
$ (cd ../../aws_dynamo; python dynamo_insert_items_from_file.py)
```

### 9. AWS Management Console
Now the stack is up you can have a look at the API Gateway in the AWS Management Console and test the API in your browser.
* API Gateway > lambda-dynamo-data-api
* Stages > Prod > Get
* Copy the Invoke URL into a new tab, e.g. https://XXXXXXXXXX.execute-api.eu-west-1.amazonaws.com/Prod/visits/{resourceId}
* You should get a message `resource_id not a number` as the ID is not valid
* Replace {resourceId} in the URL with 324
if all is working you should see some returned JSON records. Well done if so!

### 10. Deleting the stack
Go back to the main bash folder and delete the cloudFormation serverless stack.

```
$ ./delete-lambda-dynamo-data-api.sh
```


