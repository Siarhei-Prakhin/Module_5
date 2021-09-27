pipeline {
parameters {
  extendedChoice bindings: '', description: 'Choose Nginx version', groovyClasspath: '', groovyScript: '''import groovy.json.JsonSlurper
def artifactsUrl = "http://localhost:5000/v2/nginx/tags/list"
def artifactsObjectRaw = ["curl", "-s", "-H", "accept: application/json", "-k", "--url", "${artifactsUrl}"].execute().text
def jsonSlurper = new JsonSlurper()
def object = jsonSlurper.parseText(artifactsObjectRaw)
return object.tags''', multiSelectDelimiter: ',', name: 'Nginx_version', quoteValue: false, saveJSONParameterToFile: false, type: 'PT_SINGLE_SELECT', visibleItemCount: 5
}
  
agent {
    dockerfile {
        additionalBuildArgs  '--build-arg NGINX_VERSION=$Nginx_version'
    }
}
  stages {
  stage('Cleaning_the_workspace') {
    steps {
      cleanWs()
    }
  }
stage('Build and Push Docker Images'){
    steps{
        script {
            def imageName = "${containerRegistry}/${serviceName}/${optionalImageName}"
            docker.withRegistry("https://${containerRegistry}/${serviceName}", "1feb1e1e-9999-41bb-a269-89c999999999") {
                def customImage = docker.build(imageName)
                customImage.push("${newVersion}")
            }
        }
    }
}
  }
}
