def GITHUB_REPO='git@github.com:Siarhei-Prakhin/Module_5.git'
def GITHUB_BRANCH='task9'
pipeline {
parameters {
  extendedChoice bindings: '', description: 'Choose Nginx version', groovyClasspath: '', groovyScript: '''import groovy.json.JsonSlurper
def artifactsUrl = "http://localhost:5000/v2/nginx/tags/list"
def artifactsObjectRaw = ["curl", "-s", "-H", "accept: application/json", "-k", "--url", "${artifactsUrl}"].execute().text
def jsonSlurper = new JsonSlurper()
def object = jsonSlurper.parseText(artifactsObjectRaw)
return object.tags''', multiSelectDelimiter: ',', name: 'Nginx_version', quoteValue: false, saveJSONParameterToFile: false, type: 'PT_SINGLE_SELECT', visibleItemCount: 5
}
agent none

stages {
  agent any
    stage('Download src from github') {
    steps {
      git branch: "$GITHUB_BRANCH", url: "$GITHUB_REPO"
    }
  }
    stage("Test") {
      agent {
        dockerfile {
          additionalBuildArgs  '--build-arg NGINX_VERSION=$Nginx_version'
          args "-t localhost:5000/mynginx:latest"
        }
      }
            steps {
        sh "docker images"
      }
    }

}
}