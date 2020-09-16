
pipeline {
    environment {
    registry = "orinaoisera22/capstone-project"
    registryCredential = "dockerhub"
    dockerImage = ""
    }
     agent any
     stages {
         stage('Build') {
              steps {
                  sh 'echo Building...'
              }
         }
         stage('Lint HTML') {
              steps {
                  sh 'tidy -q -e *.html'
              }
         }
         stage('Build Docker Image') {
              
            steps {
                  script {
              dockerImage = docker.build(registry)
            }
              }
         }
         stage('Push Docker Image') {
             
              steps {
                     sh'sudo docker login --username orinaoisera22 --password-stdin < /home/ubuntu/pass.txt'
                     sh'sudo docker push orinaoisera22/capstone-project:latest'
                    }
              }
        stage('Create kube config file') {
             
              steps {
                      withAWS(credentials: 'aws', region: 'us-east-2') {
                          sh " aws eks --region us-east-2 update-kubeconfig --name Capstone-infra1 "
                      }
                    }
              }

         stage('Deploying') {
              steps{
                  echo 'Deploying to AWS...'
                  withAWS(credentials: 'aws', region: 'us-east-2') {
                      sh "aws eks --region us-east-2 update-kubeconfig --name Capstone-infra1"
                      sh "kubectl config use-context arn:aws:eks:us-east-2:815724397517:cluster/Capstone-infra1"
                      sh "kubectl set image orinaoisera22/capstone-project   capstone-project-deployment=orinaoisera22/capstone-project:latest"
                      sh "kubectl apply -f deploy/deployment.yml"
                      sh "kubectl get nodes"
                      sh "kubectl get deployment"
                      sh "kubectl get pod -o wide"
                      sh "kubectl get service/capstone-project-deployment"
                  }
              }
        }
        stage("Cleaning up") {
              steps{
                    echo 'Cleaning up...'
                    sh "docker system prune"
              }
        }
     }
}