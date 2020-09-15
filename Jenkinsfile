
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
                     script {
                 docker.withRegistry('', registryCredential) {
                        dockerImage.push()
                    }
              }
         }
         }
         stage('Deploying') {
              steps{
                  echo 'Deploying to AWS...'
                  withAWS(credentials: 'new', region: 'us-west-2') {
                      sh "aws eks --region us-east-2 update-kubeconfig --name Capstone-infra"
                      sh "kubectl config use-context arn:aws:eks:us-east-2:815724397517:cluster/Capstone-infra"
                      sh "kubectl set image deployments/capstone-project-deployment  capstone-project-deployment=orinaoisera22/capstone-project:tagname"
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