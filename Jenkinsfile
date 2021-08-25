def NEXUS_REPO=''
def VERSION=''
def GITHUB_REPO='git@github.com:Siarhei-Prakhin/Module_5.git'
def GITHUB_BRANCH='task5'
def DOCKERHUB_REPO='siarheiprakhin/task6'
pipeline {
  agent any
  stages {
  stage('Cleaning_the_workspace') {
    steps {
      cleanWs()
    }
  }
  stage('Download src from github') {
    steps {
      git branch: "$GITHUB_BRANCH", credentialsId: 'github-ssh-key', url: "$GITHUB_REPO"
    }
  }

  stage('Increment version in src') {
    steps {
      sh "sudo gradle increment --info"
    }
  }
  stage('Build war') {
    steps {
      sh "sudo gradle war --info"
    }
  }
  stage('Increment version in gradle.properties') {
    steps {
      sh "sudo gradle increment2 --info"
    }
  }
  stage('Push incremented version to github with tag') {
    steps { script {
      def vers='git tag '+readFile('src/main/resources/greeting.txt').trim()
      sh "$vers"
      sh "git add gradle.properties"
      sh "git commit -m 'test'"
      sshagent(['github-ssh-key']) {
           sh "git push origin task5 --tags"
                                  }
    }}
  }

stage('Upload artifact to Nexus') {
    environment {
                NEXUS_CREDS = credentials('nexus')
            }
    steps { script {
        NEXUS_REPO='http://localhost:8081/nexus/content/repositories/snapshots/test/'+readFile('src/main/resources/greeting.txt').trim()+'/test.war'
      sh "curl -v -u $NEXUS_CREDS --upload-file build/libs/test.war $NEXUS_REPO"
    }
  } 
                   }
stage('Docker') {
    steps { script {
          sh "wget $NEXUS_REPO"
          VERSION=readFile('src/main/resources/greeting.txt').trim()
          sh "docker build -t $DOCKERHUB_REPO:$VERSION --build-arg NEXUS_REPO_ARG=$NEXUS_REPO ."
          
          withDockerRegistry([ credentialsId: "dockerhub", url: "" ]) {
          sh "docker push $DOCKERHUB_REPO:$VERSION"
        }

          } 
                           }
                    }  
  stage('Update docker swarm image') {
    steps {
      sh "docker service update --image=$DOCKERHUB_REPO:$VERSION tomcat"
    }
  }                    
                    
  }
}
