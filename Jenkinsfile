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
        stage('Creating ConfigMap') {
            steps {
                withCredentials([string(credentialsId: 'Access-key-ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'Secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'kubectl apply -f k8s/configmap.yml'
                }
            }
        }
        stage('Creating mysql pv & pvc') {
            steps {
                withCredentials([string(credentialsId: 'Access-key-ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'Secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'kubectl apply -f k8s/mysql-pv.yml'
                }
            }
        }
        stage('Creating mysql statefulset & its service') {
            steps {
                withCredentials([string(credentialsId: 'Access-key-ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'Secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'kubectl apply -f k8s/statefulset.yml'
                }
            }
        }
        stage('Creating flaskapp deployment & its service') {
            steps {
                withCredentials([string(credentialsId: 'Access-key-ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'Secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'kubectl apply -f k8s/deployment.yml'
                }
            }
        }

        stage('install nginx ingress controller & Creating ingress') {
            steps {
                withCredentials([string(credentialsId: 'Access-key-ID', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'Secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx'
                    sh 'helm install flask-app-ingress ingress-nginx/ingress-nginx -f k8s/values.yml'
                    sh 'kubectl apply -f k8s/ingress.yml'
                    sh 'kubectl describe svc flask-app-ingress-ingress-nginx-controller | grep "LoadBalancer Ingress"'
                }
            }
        }
    }
}