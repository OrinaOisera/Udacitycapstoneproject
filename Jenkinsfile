
pipeline {
    environment {
    registry = "orinaoisera22/capstone-project"
    registryCredential = "dockerhub"
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
                  withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
                  sh 'docker build -t  capstone-project .'
                  }
              }
         }
         stage('Push Docker Image') {
              steps {
                   {  sh 'docker login --username orinaoisera22'
                      sh "docker tag capstone-project orinaoisera22/capstone-project"
                      sh 'docker push orinaoisera22/capstone-project'
            
                  }
              }
         }
         stage('Deploying') {
              steps{
                  echo 'Deploying to AWS...'
                  withAWS(credentials: 'aws', region: 'us-west-2') {
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