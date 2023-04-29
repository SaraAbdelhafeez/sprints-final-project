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

__Build Infrastructure__

Clone [sprints-final-project](https://github.com/SaraAbdelhafeez/sprints-final-project.git) Repo then: 
```
terraform init
```
```
terraform apply --auto-approve
```
Terraform output is the ip of Jenkins ec2

![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/jenkins_ip.PNG?raw=true)

## Ansible Configuration
* terraform will run ansible so you don't have to run ansible
* Ansible will configure jenkins, docker and awscli and adding aws credentials
* ansible will print the initial password of jenkins

![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/jenkins_pass.PNG?raw=tru)

## Jenkins 
__Browse with jenkins ip__

```
http://54.208.8.147:8080/
```
you don't need to install any plugins only the suggested pugins

![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/plugins.PNG?raw=true)

__Create webhook__

Go to [sprints-final-project](https://github.com/SaraAbdelhafeez/sprints-final-project.git) repo (i add you as a collaborator)

![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/webhook-3.PNG?raw=true)

__Add GitHub Token and AWS Credentials in Jenkins Dashboard__

Dashboard > Manage Jenkins > Credentials > System > Global credentials (unrestricted)


![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/credentials.PNG?raw=true)


__Create the Pipeline__

1. build-pipeline 

![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/first-pipeline.PNG?raw=true)

Dashboard > build-pipeline > Configuration > Build Triggers

check __GitHub hook trigger for GITScm polling__ option

![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/build-triggrs.PNG?raw=true)

Dashboard > build-pipeline > Configuration > Pipeline

add the [sprints-final-project](https://github.com/SaraAbdelhafeez/sprints-final-project.git) and its Credentials and make sure that __Branches to build__ is __main__ 

![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/prod-repo.PNG?raw=true)

__Script Path__
```
Jenkinsfile
```


So, with every push event in sprints-final-project repo the build-pipeline will build and give you the link of the ingress controller loadbalancer to access the application with it



![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/output.PNG?raw=true)


![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/website.PNG?raw=true)


## Destroying the environment

delete the ECRs first
```
aws ecr delete-repository --repository-name flask-app --force
```
```
aws ecr delete-repository --repository-name mysql-db --force
```
```
terraform destroy --auto-approve
```

