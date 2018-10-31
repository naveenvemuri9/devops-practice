pipeline{
    agent none
    options{
        timestamps()
        buildDiscarder(logRotator(daysToKeepStr:'14'))
    }

    environment {

    }
    parameters {
        choice(name: 'OP_TYPE', choices: 'CREATE CLUSTER\nDESTROY CLUSTER\nINSTALL GO APP', description: 'Type of Operation')
        string(name: 'CLUSTER_NAME', defaultValue: "", description: 'Provide unique alphanumeric value')
    }
    stages{

        stage("create and deploy stage"){
          agent any
          steps{
            deleteDir()
            checkout scm
              withCredentials([
                usernamePassword(credentialsId: 'jenkins_artifactory_credentials', passwordVariable: 'ART_PASS', usernameVariable: 'ART_USER')
              ]){
                 script{
                    if (env.OP_TYPE == 'CREATE CLUSTER') {
                      ansiColor('xterm'){
                                      echo 'Creating node'
                                      sh(script: 'ansible-playbook --extra-vars' +
                                              ' "cluster_name=$CLUSTER_NAME k8s_cluster.yaml')
                                      sh(script: 'echo Cluster IP:')
                                     }
                    } else if (env.OP_TYPE == 'INSTALL GO APP') {
                        ansiColor('xterm') {
                            echo 'Installing Go App'
                            sh(script: '''
                              ansible-playbook --extra-vars ' "platform": '"$ENVIRONMENT"' ' install_go_app.yaml
                             ''')
                        }
                    } else if (env.OP_TYPE == 'DESTROY CLUSTER') {
                      ansiColor('xterm'){
                                      echo 'Deleting node'
                                      sh(script: 'ansible-playbook --extra-vars' +
                                              ' "cluster_name=$CLUSTER_NAME platform=$ENVIRONMENT" destroy_cluster.yaml')
                       }
                    }  
                 }
              }
           }
           post{
            success{
                withCredentials([usernamePassword(credentialsId: 'jenkins_artifactory_credentials', passwordVariable: 'ART_PASS', usernameVariable: 'ART_USER')]){
                    script{
                      archiveArtifacts artifacts: "clusters_state/${CLUSTER_NAME}/*"
                    }
                }
            }
            failure{
              slackSend channel: '#prototype-jenkins', color: 'danger', message: "Build stage failed: ${env.BUILD_TAG}. Job: ${env.BUILD_URL}", tokenCredentialId: 'jenkins_slack_credentials'
            }
          }
        }
    }
}
