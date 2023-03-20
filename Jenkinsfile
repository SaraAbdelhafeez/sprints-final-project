pipeline {
    agent any
    parameters {
        booleanParam(name: 'RUN_BUILD', defaultValue: true)
    }
    stages {
        stage('aws erc login') {
            steps {
                withCredentials([string(credentialsId: 'Access-key-ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'Secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'aws ecr get-login-password | docker login --username AWS --password-stdin 524041749761.dkr.ecr.us-east-1.amazonaws.com/flask-app'
                    sh 'aws ecr get-login-password | docker login --username AWS --password-stdin 524041749761.dkr.ecr.us-east-1.amazonaws.com/mysql-db'
                }
            }
        }
        stage('build the images') {
            steps {
                sh 'docker build -t 524041749761.dkr.ecr.us-east-1.amazonaws.com/flask-app:latest ./FlaskApp'
                sh 'docker build -t 524041749761.dkr.ecr.us-east-1.amazonaws.com/mysql-db:latest ./MySQL_Queries'
            }
        }
        stage('push the images') {
            steps {
                withCredentials([string(credentialsId: 'Access-key-ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'Secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'docker push 524041749761.dkr.ecr.us-east-1.amazonaws.com/flask-app:latest'
                    sh 'docker push 524041749761.dkr.ecr.us-east-1.amazonaws.com/mysql-db:latest'
                    sh 'echo "build is done!"'
                  
                }
            }
        }
        stage('add kube-cnofig') {
            steps {
                withCredentials([string(credentialsId: 'Access-key-ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'Secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'aws eks --region us-east-1 update-kubeconfig --name eks'
                }
            }
        }
        stage('Applying K8s manifest') {
            steps {
                withCredentials([string(credentialsId: 'Access-key-ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'Secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    echo "creating ConfigMap"
                    sh 'kubectl apply -f k8s/configmap.yml'
                    echo "Creating mysql pv & pvc"
                    sh 'kubectl apply -f k8s/mysql-pv.yml'
                    echo 'Creating mysql statefulset & its service'
                    sh 'kubectl apply -f k8s/statefulset.yml'
                    echo 'Creating flaskapp deployment & its service'
                    sh 'kubectl apply -f k8s/deployment.yml'
                }
            }
        }

        stage('install nginx ingress controller') {
            // when {   //uncomment this block after the first build
                
            //         expression { 
            //             return 
            //             withCredentials([string(credentialsId: 'Access-key-ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'Secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
            //             sh 'helm list -q' 
            //             } != 'flask-app-ingress' 
            //         }
                
            // }
            when {
                expression {
                    return params.RUN_BUILD
                }

            }
            steps {
                
                withCredentials([string(credentialsId: 'Access-key-ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'Secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    
                    sh 'helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx'
                    sh 'helm install flask-app-ingress ingress-nginx/ingress-nginx -f k8s/values.yml'
                }
                $params.RUN_BUILD = false
            }
        }
        stage('Creating ingress') {
            steps {
                withCredentials([string(credentialsId: 'Access-key-ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'Secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'sleep 1m'
                    sh 'kubectl apply -f k8s/ingress.yml'
                    sh 'kubectl describe svc flask-app-ingress-ingress-nginx-controller | grep "LoadBalancer Ingress"'
                    sh 'echo "Just wait 3-5 minutes (only in the first build) untill the loadbalancer be Active"'
                }
            }
        }
    }
}
