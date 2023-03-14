pipeline {
    agent any
    stages {
        stage('add kube-cnofig') {
            steps {
                sh 'aws eks --region us-east-1 update-kubeconfig --name eks'
            }
        }
        stage('Creating ConfigMap') {
            steps {
                sh 'kubectl apply -f k8s/configmap.yml'
            }
        }
        stage('Creating mysql pv & pvc') {
            steps {
                sh 'kubectl apply -f k8s/mysql-pv.yml'
            }
        }
        stage('Creating mysql statefulset & its service') {
            steps {
                sh 'kubectl apply -f k8s/statefulset.yml'
            }
        }
        stage('Creating flaskapp deployment & its service') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yml'
            }
        }
        
    }
}