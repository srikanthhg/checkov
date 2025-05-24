// plugins installed: pipeline stage view, docker, terraform, aws 
pipeline {
    agent any
    tools {
        terraform 'terraform'
        
    }

    parameters {
        // choice(name: 'CHOICES', choices: ['apply', 'destroy' ], description: '')

        // booleanParam(name: 'terraform_apply', defaultValue: true, description: 'Toggle this value')

        choice(name: 'CHOICE', choices: ['apply', 'destroy' ], description: 'pick terraform apply or terraform destroy')
    }
    stages {
        stage('checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/srikanthhg/checkov.git'
            }
        }
        stage('Test') {
            steps {
                script {
                    docker.image('bridgecrew/checkov:latest').inside("--entrypoint=''") {
                        // Run Checkov to scan the code
                        sh 'checkov -d .'
                    }
                }
            }
        }
        stage('init') {
            steps {
                // ${params.CHOICES} == 'destroy'
                sh "terraform init"
            }
        }
        stage('Lint') {
            steps {
                // Run Terraform fmt to check formatting
                sh 'terraform fmt -recursive'
                // Run Terraform validate to check for syntax errors
                sh 'terraform validate'
            }
        }
        stage('Apply') {
            when {
                expression { params.CHOICE == 'apply' }
            }
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws_cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'terraform plan -out=tfplan'
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
        stage('Destroy') {
            when {
                expression { params.CHOICE == 'destroy' }
            }
            steps {

                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws_cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        always {
            echo 'This will always run after the pipeline completes.'
        }
        success {
            echo 'message: "✅ Pipeline succeeded"'
        }
        failure {
            echo 'message: "❌ Pipeline failed.'
        }
    }
}



// pipeline {
//     agent any

//     environment {
//         TF_VAR_region = 'us-east-1'
//     }

//     stages {
//         stage('Checkout') {
//             steps {
//                 git 'https://github.com/srikanthhg/checkov.git'
//             }
//         }

//         stage('Terraform Lint') {
//             steps {
//                 sh 'terraform fmt -check || true'
//                 sh 'terraform validate'
//                 sh 'tflint || true'
//             }
//         }

//         stage('Security Scan - Checkov') {
//             steps {
//                 docker.image('bridgecrew/checkov:latest').inside {
//                     sh 'checkov -d .'
//                 }
//             }
//         }

//         stage('Terraform Init & Plan') {
//             steps {
//                 sh 'terraform init'
//                 sh 'terraform plan -out=tfplan'
//             }
//         }

//         stage('Manual Approval') {
//             when {
//                 branch 'main'
//             }
//             steps {
//                 input message: "Deploy to Production?"
//             }
//         }

//         stage('Terraform Apply') {
//             when {
//                 branch 'main'
//             }
//             steps {
//                 sh 'terraform apply -auto-approve tfplan'
//             }
//         }

//         stage('Post Actions') {
//             steps {
//                 echo "Pipeline completed."
//             }
//         }
//     }

//     post {
//         always {
//             echo "This runs always"
//         }
//         failure {
//             echo "Pipeline failed!"
//         }
//     }
// }
