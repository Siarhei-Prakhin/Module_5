def NEXUS_REPO=''
def VERSION=''
pipeline {
  agent any
  stages {
  stage('Cleaning_the_workspace') {
    steps {
      sh "sudo rm -R * .gradle/ .git/ &>/dev/null"
    }
  }
  stage('Download src from github') {
    steps {
      git branch: 'task5', credentialsId: 'github-ssh-key', url: 'git@github.com:Siarhei-Prakhin/Module_5.git'
      sh "pwd"
      sh "sudo cp /home/vagrant/Dockerfile ."
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
 //     vers = sh(returnStdout: true, script: 'cat ./src/main/resources/greeting.txt').trim()
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
    steps { script {
        NEXUS_REPO='http://localhost:8081/nexus/content/repositories/snapshots/test/'+readFile('src/main/resources/greeting.txt').trim()+'/test.war'
      sh "curl -v -u admin:admin123 --upload-file build/libs/test.war $NEXUS_REPO"
    }
  } 
                   }
stage('Docker') {
    steps { script {
          sh "wget $NEXUS_REPO"
          VERSION=readFile('src/main/resources/greeting.txt').trim()
          sh "sudo docker build -t siarheiprakhin/task6:$VERSION --build-arg NEXUS_REPO_ARG=$NEXUS_REPO ."
          sh "sudo docker push siarheiprakhin/task6:$VERSION"
        
          } 
                           }
                    }       
  }
}
