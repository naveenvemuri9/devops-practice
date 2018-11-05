pipeline{
    agent none
    options{
        timestamps()
        buildDiscarder(logRotator(daysToKeepStr:'14'))
    }

    parameters {
        choice(name: 'OP_TYPE', choices: 'CREATE CLUSTER\nDESTROY CLUSTER\nINSTALL GO APP\nUNINSTALL GO APP', description: 'Type of Operation')
        string(name: 'CLUSTER_NAME', defaultValue: "", description: 'Provide unique alphanumeric value')
    }
    stages{

        stage("Build Docker Image"){
          agent any
          steps{
            checkout scm
             withCredentials([usernamePassword(credentialsId: 'jenkins_dockerhub_credentials', passwordVariable: 'DOCKER_HUB_PASSWORD', usernameVariable: 'DOCKER_HUB_USER')]){
                 script{
                       sh "docker login -u ${env.DOCKER_HUB_USER} -p ${env.DOCKER_HUB_PASSWORD}"
                       sh "cd ./go-app && docker build -t go-app ."
                       sh "docker tag go-app naveenvemuri9/go-app:latest" 
                       sh "docker push naveenvemuri9/go-app:latest"
                 }
            }
        }
      }
        stage("create and deploy stage"){
          agent any
          steps{
            deleteDir()
            checkout scm
                 script{
                    if (env.OP_TYPE == 'CREATE CLUSTER') {
                      ansiColor('xterm'){
                                      echo 'Creating node'
                                      sh(script: 'ansible-playbook --extra-vars' +
                                              ' "cluster_name=$CLUSTER_NAME" eks_provision_cluster.yaml')
                                      sh(script: 'echo Cluster IP:')
                                     }
                    } else if (env.OP_TYPE == 'INSTALL GO APP') {
                        ansiColor('xterm') {
                            echo 'Installing Go App'
                                      sh(script: 'ansible-playbook --extra-vars' +
                                              ' "cluster_name=$CLUSTER_NAME" deployment.yaml')                            
                        }
                    } else if (env.OP_TYPE == 'DESTROY CLUSTER') {
                      ansiColor('xterm'){
                                      echo 'Deleting node'
                                      sh(script: 'ansible-playbook --extra-vars' +
                                              ' "cluster_name=$CLUSTER_NAME" destroy_cluster.yaml')
                       }
                    } else if (env.OP_TYPE == 'UNINSTALL GO APP') {
                      ansiColor('xterm'){
                                      echo 'Deleting node'
                                      sh(script: 'ansible-playbook uninstall-go-app.yaml')
                       }
                    }                     
                 }
              }
        }
    }
}
