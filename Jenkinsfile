pipeline {
    agent any

    environment {
        IMAGE_NAME = 'django-app'  // Docker image name
        DOCKER_TAG = 'latest'  // Docker tag
        DJANGO_PORT = '8000'   // External port for Django app
        INTERNAL_PORT = '8000' // Internal port for Django app
    }

    tools {
        python 'Python3'  // Ensure Python is configured in Jenkins
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()  // Clears the workspace at the start
            }
        }

        stage('Checkout SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/YOUR_USERNAME/YOUR_DJANGO_REPO.git'  // Replace with your Django repo
            }
        }
        
        stage('List Files') {
            steps {
                sh 'ls -la'  // List all files to verify Dockerfile presence
            }
        }       

        stage('Check Dockerfile') {
            steps {
                script {
                    if (!fileExists('Dockerfile')) {
                        error('Dockerfile not found! Aborting build.')
                    }
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip install -r requirements.txt'  // Install dependencies
            }
        }

        stage('Run Django Migrations') {
            steps {
                sh 'python manage.py migrate'  // Run migrations
            }
        }

        stage('Run Django Tests') {
            steps {
                sh 'python manage.py test'  // Run Django tests
            }
        }

        stage('Test Docker') {
            steps {
                sh 'docker --version'  // Verifies Docker is installed and available
                sh 'docker ps'         // Lists running Docker containers to verify Docker is working
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${DOCKER_TAG}", "-f ./Dockerfile .")
                }
            }
        }

        stage('Run Django Docker Container') {
            steps {
                script {
                    try {
                        // Stop and remove existing container if it exists
                        sh "docker stop ${IMAGE_NAME}_container || true"
                        sh "docker rm ${IMAGE_NAME}_container || true"

                        // Run Docker container for the Django application
                        sh "docker run -d --name ${IMAGE_NAME}_container -p ${DJANGO_PORT}:${INTERNAL_PORT} ${IMAGE_NAME}:${DOCKER_TAG}"
                        
                        // Verify running containers
                        sh 'docker ps'
                    } catch (Exception e) {
                        error("Failed to run Docker container: ${e.message}")
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Build and deployment succeeded!'
        }

        failure {
            echo 'Build failed!'
        }

        always {
            cleanWs()  // Clean workspace after the build (optional)
        }
    }
}
