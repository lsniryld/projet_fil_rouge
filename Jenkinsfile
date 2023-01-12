pipeline {
    environment {
        IMAGE_NAME = "icwebapp"
        APP_CONTAINER_PORT = "8080"
        DOCKERHUB_ID = "lsniryniry"
        //DOCKERHUB_PASSWORD = credentials('dockerhub_password')
	IMAGE_TAG= "v1"
	    
    }
    agent none
    stages {
       stage('Build image') {
           agent any
           steps {
              script {
                sh 'docker build --no-cache -f ./Dockerfile -t ${DOCKERHUB_ID}/$IMAGE_NAME:$IMAGE_TAG .'
                
              }
           }
       }
      /* stage('Scan Image with  SNYK') {
            agent any
            environment{
                SNYK_TOKEN = credentials('snyk_token')
            }
            steps {
                script{
                    sh '''
                    echo "Starting Image scan ${DOCKERHUB_ID}/$IMAGE_NAME:$IMAGE_TAG ..." 
                    echo There is Scan result : 
                    SCAN_RESULT=$(docker run --rm -e SNYK_TOKEN=$SNYK_TOKEN -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/app snyk/snyk:docker snyk test --docker $DOCKERHUB_ID/$IMAGE_NAME:$IMAGE_TAG --json ||  if [[ $? -gt "1" ]];then echo -e "Warning, you must see scan result \n" ;  false; elif [[ $? -eq "0" ]]; then   echo "PASS : Nothing to Do"; elif [[ $? -eq "1" ]]; then   echo "Warning, passing with something to do";  else false; fi)
                    echo "Scan ended"
                    '''
                }
            }
        }*/
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
                   curl -I ${HOST_IP} 
                '''
              }
           }
       }
       /*stage('Clean container') {
          agent any
          steps {
             script {
               sh '''
                   docker stop $IMAGE_NAME
                   docker rm $IMAGE_NAME
               '''
             }
          }
        }*/

       stage ('Login and Push Image on docker hub') {
          agent any
	  environment {
             DOCKERHUB_PASSWORD  = credentials('dockerhub_password')
          } 
          steps {
             script {
               sh '''
                   echo "envoi docker hub"
		   
               '''
             }
          }
        }

    }
 
}
