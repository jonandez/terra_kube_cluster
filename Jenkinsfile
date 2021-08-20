properties([parameters([choice(choices: 'apply\ndestroy', name: 'action')])])

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
                sh "cd prod/kubernetes_cluster/ && rm terraform.tfstate terraform.tfstate.backup && terraform init"
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
                sh "cd prod/kubernetes_cluster/ && terraform plan -var-file='vars.tfvars'"
            }
        }
        stage ("terraform action") {
            steps {
                sh "cd prod/kubernetes_cluster/ && terraform ${params.action} -var-file='vars.tfvars' --auto-approve"
            }
        }
    }
}