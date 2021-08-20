pipeline {
    agent any
    
    tools {
        terraform 'terraform'
    }
    
    stages {
        stage ("checkout from git"){
            steps {
                git 'https://github.com/jonandez/terra_kube_cluster.git'
            }
        }
        stage ("terraform init") {
            steps {
                sh "cd prod/kubernetes_cluster/ && terraform init"
            }
        }
        stage ("terraform fmt") {
            steps {
                sh "cd prod/kubernetes_cluster/ && terraform fmt"
            }
        }
        stage ("terraform validate") {
            steps {
                sh "cd prod/kubernetes_cluster/ && terraform validate"
            }
        }
        stage ("terraform plan") {
            steps {
                sh "cd prod/kubernetes_cluster/ && rm terraform.tfstate terraform.tfstate.backup && terraform plan -var-file='vars.tfvars'"
            }
        }
        stage ("terraform apply") {
            steps {
                sh "cd prod/kubernetes_cluster/ && terraform apply -var-file='vars.tfvars' --auto-approve"
            }
        }
    }
}