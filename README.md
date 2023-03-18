# sprints-final-project
building infrastructure with terraform with all needed configuration with ansible for MYSQL-FLASK-APP production

## AWS Infrastructure using Terraform
### network module
* VPC
* 2 Public Subnets
* Route Table 
* Internet Getway
### EKS module
* eks
* nodes
### ECR module
* flask-app ecr
* mysql-db ecr
### EC2 module
* Security Group
* key Pair
* ec2 

<!-- __AWS Credentials__
```
echo "[default]\naws_access_key_id = AKIAXUA2SQUAYH2SXYUD\naws_secret_access_key = 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" >> ~/.aws/credentials

echo "[default]\nregion = us-east-1\noutput = json" >> ~/.aws/config
``` -->
__Build Infrastructure__
```
terraform init
```
```
terraform apply --auto-approve
```
Terraform output is the ip of Jenkins ec2
![]()

