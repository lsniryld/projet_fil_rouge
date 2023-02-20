pipeline {
   environment {
        IMAGE_NAME = "icwebapp"
        APP_CONTAINER_PORT = "8080"
        DOCKERHUB_ID = "lsniryniry"
        DOCKERHUB_PASSWORD = credentials('dockerhub_password')
	IMAGE_TAG= "v1"
        APP_EXPOSED_PORT="8081"
        HOST_IP="192.168.237.40"
	    
    }
	agent none
	stages{
	   stage('Build image') {
	       agent any
           steps {
              script {
                sh 'docker build --no-cache -f ./Dockerfile -t ${DOCKERHUB_ID}/$IMAGE_NAME:$IMAGE_TAG .'
                
              }
           }
	   }
	   
	   stage('Run container based on builded image') {
          agent any
          steps {
            script {
              sh '''
                  echo "Cleaning existing container if exist"
                  docker ps -a | grep -i $IMAGE_NAME && docker rm -f ${IMAGE_NAME}
                  docker run --name ${IMAGE_NAME} -d -p $APP_EXPOSED_PORT:$APP_CONTAINER_PORT  ${DOCKERHUB_ID}/$IMAGE_NAME:$IMAGE_TAG
                  sleep 5
              '''
             }
          }
       }
	   
	   stage('Test image') {
           agent any
           steps {
              script {
                sh '''
                   curl -I http://${HOST_IP}:${APP_EXPOSED_PORT} | grep "200"
                '''
              }
           }
       }
	   
	   stage('Clean container') {
          agent any
          steps {
             script {
               sh '''
                   docker stop $IMAGE_NAME
                   docker rm $IMAGE_NAME
               '''
             }
          }
        }
		
		stage('Deploy application ') {
		   agent { docker { image 'registry.gitlab.com/robconnolly/docker-ansible:latest'  } }
		   stages {
		      stage ('Prepare ansible environment') {
			     agent any
                 environment {
                    VAULT_KEY = credentials('vault_key')
                    PRIVATE_KEY = credentials('private_key')
                 }
                  steps {
                     script {
                       sh '''
                       echo $VAULT_KEY > vault.key
                       echo $PRIVATE_KEY > id_rsa
                       chmod 700 id_rsa
                       '''
                     }      
                  }				 
			  }
			  
			  stage ("Ping hosts") {
                steps {
                    script {
                        sh '''
                            apt update -y
                            apt install sshpass -y 
                            export ANSIBLE_CONFIG=$(pwd)/ansible/ansible.cfg
                            ansible all --list-hosts --private-key id_rsa  
                        '''
                    }
                }
            }
		   
        }
		
    }
	   
  }
	
}
