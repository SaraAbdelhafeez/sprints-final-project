pipeline {
    agent any
    stages {
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
            when {
                
                    expression { 
                        return $BUILD_NUMBER != 1 ||
                        withCredentials([string(credentialsId: 'Access-key-ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'Secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh 'helm list -q' 
                        } != 'flask-app-ingress' 
                    }
                
            }
            steps {
                withCredentials([string(credentialsId: 'Access-key-ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'Secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    
                    sh 'helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx'
                    sh 'helm install flask-app-ingress ingress-nginx/ingress-nginx -f k8s/values.yml'
                }
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
