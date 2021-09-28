def GITHUB_REPO='https://github.com/Siarhei-Prakhin/Module_5.git'
def GITHUB_BRANCH='task9'
def LOCAL_REPO_AND_IMAGE_NAME='localhost:5000/mynginx:latest'
pipeline {
parameters {
  extendedChoice bindings: '', description: 'Choose Nginx version', groovyClasspath: '', groovyScript: '''import groovy.json.JsonSlurper
def artifactsUrl = "http://localhost:5000/v2/nginx/tags/list"
def artifactsObjectRaw = ["curl", "-s", "-H", "accept: application/json", "-k", "--url", "${artifactsUrl}"].execute().text
def jsonSlurper = new JsonSlurper()
def object = jsonSlurper.parseText(artifactsObjectRaw)
return object.tags''', multiSelectDelimiter: ',', name: 'Nginx_version', quoteValue: false, saveJSONParameterToFile: false, type: 'PT_SINGLE_SELECT', visibleItemCount: 5
}
agent any

stages {
  
    stage('Download src from github') {
       steps {
          git branch: "$GITHUB_BRANCH", url: "$GITHUB_REPO"
             }
                                       }
    stage('Modify Dockerfile according to choosen extended parameter') {
       steps {
          sh "sed -i 's/NGINX_VERSION/$Nginx_version/' Dockerfile"
             }
                                                                        }
  
    stage('Build and push image to local repository') {
       steps {
         script {
             def NGINX = docker.build("$LOCAL_REPO_AND_IMAGE_NAME")
             NGINX.push('')
                }
             }
                                                       }  


}
}
