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

Add GitHub Token as __Username with password__
* GitHub Username
```
SaraAbdelhafeez
```
* GitHub Token
```
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
```
Add AWS Credentials as __secret text__

* Access key ID
    
    * ID
    ```
    Access-key-ID
    ```
    * Secret
    ```
    AKIAXUA2SQUAYH2SXYUD
    ```
* Secret access key

    * ID 
    ```
    Secret-access-key
    ```
    * Secret
    ```
    bCiTptl6RqyBJ2xj61FAv36ZohUAurcJAyw0ap1c
    ```
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
<!-- 2. production-pipeline

![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/second-pipeline.PNG?raw=true)

Dashboard > build-pipeline > Configuration > Build Triggers

check __Build after other projects are built__ option and __Projects to watch__ is build-pipeline then choose __Trigger only if build is stable__

![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/prod-triggrs.PNG?raw=true)

Dashboard > build-pipeline > Configuration > Pipeline

add the [sprints-final-project](https://github.com/SaraAbdelhafeez/sprints-final-project.git) and its Credentials and make sure that __Branches to build__ is __main__ 

![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/prod-repo.PNG?raw=true)

__Script Path__
```
Jenkinsfile
``` -->

So, with every push event in sprints-final-project repo the build-pipeline will build and give you the link of the ingress controller loadbalancer to access the application with it

<!-- ![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/pipeline1-build1.PNG?raw=true)

![image](https://github.com/SaraAbdelhafeez/git-task/blob/main/pipeline2-build1.PNG?raw=true) -->

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

delete the loadbalancers
```
aws elbv2 describe-load-balancers | grep LoadBalancerName
```
the output will be like this 
```
 "LoadBalancerName": "a7c16e5c383fa46c2aa8b5ce7a389cbb",
 "LoadBalancerName": "ad63f1154590c40f5b598c8eedddba98",
```
copy the name of each on and run:
```
aws elb delete-load-balancer --load-balancer-name a7c16e5c383fa46c2aa8b5ce7a389cbb
```
```
aws elb delete-load-balancer --load-balancer-name ad63f1154590c40f5b598c8eedddba98
```
now you can destroy
```
terraform destroy --auto-approve
```
# NOTE

In Jenkinsfile in [sprints-final-project](https://github.com/SaraAbdelhafeez/sprints-final-project.git) repo 
uncomment the stage called 'install nginx ingress controller' after the first build, if you don't the build will fail because it can't re-install anthor ingress controller with the same name.

# Thank you for this FUN project :)