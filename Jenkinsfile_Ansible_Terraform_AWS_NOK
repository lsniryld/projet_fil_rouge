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
	   /*stage('Build image') {
	       agent any
           steps {
              script {
                sh 'docker build --no-cache -f ./Dockerfile -t ${DOCKERHUB_ID}/$IMAGE_NAME:$IMAGE_TAG .'
                
              }
           }
	   }*/
	   
	   /*stage('Run container based on builded image') {
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
       }*/
	   
	   /*stage('Test image') {
           agent any
           steps {
              script {
                sh '''
                   curl -I http://${HOST_IP}:${APP_EXPOSED_PORT} | grep "200"
                '''
              }
           }
       }*/
	   
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

		stage ('Build EC2 on AWS with terraform') {
          agent { 
                    docker { 
                            image 'jenkins/jnlp-agent-terraform'  
                    } 
                }
          environment {
            AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
            AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
            PRIVATE_AWS_KEY = credentials('private_aws_key')
          }          
          steps {
             script {
               sh '''
                  echo "Generating aws credentials"
                  echo "Deleting older if exist"
                  rm -rf devops.pem ~/.aws 
                  rm -rf /var/jenkins_home/workspace/projet_fil_rouge/public_ip.txt
                  rm -rf /var/jenkins_home/workspace/projet_fil_rouge/ansible/host_vars/odoo_server_dev.yml
                  rm -rf /var/jenkins_home/workspace/projet_fil_rouge/ansible/host_vars/ic_webapp_server_dev.yml
                  rm -rf /var/jenkins_home/workspace/projet_fil_rouge/ansible/host_vars/pg_admin_server_dev.yml
                  rm -rf 
                  mkdir -p ~/.aws
                  echo "[default]" > ~/.aws/credentials
                  echo -e "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
                  echo -e "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
                  chmod 700 ~/.aws/credentials
                  echo "Generating aws private key"
                  cp $PRIVATE_AWS_KEY devops.pem
                  chmod 777 devops.pem
                  cp devops.pem ./terraform/
                  cp devops.pem ./terraform/modules/ec2module/
                  cd "./terraform/app"
                  terraform init 
                  terraform destroy --auto-approve
                  terraform plan
                  terraform apply --auto-approve
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
            VAGRANT_PASSWORD = credentials('vagrant_password')
					}
					steps {
						script {
							sh '''
							echo $VAULT_KEY > vault.key
							echo $PRIVATE_KEY > id_rsa
							chmod 700 id_rsa
							echo "Cleaning workspace before starting"
                            rm -f vault.key id_rsa id_rsa.pub password
                            echo "Generating vault key"
                            echo -e $VAULT_KEY > vault.key
                            echo "Generating private key"
                            cp $PRIVATE_KEY  id_rsa
                            chmod 400 id_rsa vault.key
							echo "Generating host_vars for EC2 servers"
                            echo "ansible_host: $(awk '{print $2}' /var/jenkins_home/workspace/projet_fil_rouge/public_ip.txt)" > /var/jenkins_home/workspace/projet_fil_rouge/ansible/host_vars/odoo_server_dev.yml
                            echo "ansible_host: $(awk '{print $2}' /var/jenkins_home/workspace/projet_fil_rouge/public_ip.txt)" > /var/jenkins_home/workspace/projet_fil_rouge/ansible/host_vars/ic_webapp_server_dev.yml
                            echo "ansible_host: $(awk '{print $2}' /var/jenkins_home/workspace/projet_fil_rouge/public_ip.txt)" > /var/jenkins_home/workspace/projet_fil_rouge/ansible/host_vars/pg_admin_server_dev.yml
                            echo "Generating host_pgadmin_ip and  host_odoo_ip variables"
                            echo "host_odoo_ip: $(awk '{print $2}' /var/jenkins_home/workspace/projet_fil_rouge/public_ip.txt)" >> /var/jenkins_home/workspace/projet_fil_rouge/ansible/host_vars/ic_webapp_server_dev.yml
                            echo "host_pgadmin_ip: $(awk '{print $2}' /var/jenkins_home/workspace/projet_fil_rouge/public_ip.txt)" >> /var/jenkins_home/workspace/projet_fil_rouge/ansible/host_vars/ic_webapp_server_dev.yml

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
                            echo ${GIT_BRANCH}
							'''
						}
					}
				}
			   
	            /*stage ("Check all playbook syntax") {
					steps {
						script {
							sh '''
								export ANSIBLE_CONFIG=$(pwd)/ansible/ansible.cfg
								ansible-playbook ansible/playbooks/deploy-ic-webapp.yml --syntax-check -vvv
								ansible-playbook ansible/playbooks/install-docker.yml --syntax-check -vvv
								ansible-playbook ansible/playbooks/deploy-odoo.yml --syntax-check -vvv
								ansible-playbook ansible/playbooks/deploy-pgadmin.yml --syntax-check -vvv								
								echo ${GIT_BRANCH}                                         
							'''
						}
					}
				}*/
			   
			   stage ("Deploy in ec2 aws") {
          
					when { expression { GIT_BRANCH == 'origin/main'} }
					stages {
						stage ("AWS - Install Docker on all hosts") {
						    steps {
								script {
									sh '''
										export ANSIBLE_CONFIG=$(pwd)/ansible/ansible.cfg
                    echo $ANSIBLE_CONFIG
										ansible-playbook ansible/playbooks/install-docker.yml  --private-key devops.pem -l odoo_server_dev
									'''
								}
							}
						}
						
						stage ("Deploy pgadmin") {
							steps {
								script {
									sh '''
                                    export ANSIBLE_CONFIG=$(pwd)/ansible/ansible.cfg
                                    ansible-playbook ansible/playbooks/deploy-pgadmin.yml --vault-password-file vault.key  --private-key devops.pem -l pg_admin_server_dev
									'''
								}
							}
						}
						
						stage ("Deploy odoo") {
							steps {
								script {
									sh '''
                                    export ANSIBLE_CONFIG=$(pwd)/ansible/ansible.cfg
                                    ansible-playbook ansible/playbooks/deploy-odoo.yml --vault-password-file vault.key  --private-key devops.pem -l odoo_server_dev
									'''
								}
							}
						}

						stage ("Deploy ic-webapp") {
							steps {
								script {
									sh '''
                                    export ANSIBLE_CONFIG=$(pwd)/ansible/ansible.cfg
                                    ansible-playbook ansible/playbooks/deploy-ic-webapp.yml --vault-password-file vault.key --private-key id_rsa -l ic_webapp_server_dev
									'''
								}
							}
						}
					}
			   }
		   
        }
		
    }
	   
  }
	
}
