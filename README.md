# Short workflow of DevOPS practical task №8
## 1) Preparation stage:
 a) Container "registry" was started.  
 b) Docker image with OS was builded according to the Dockerfile in "temp" directory.  
 c) Then the image was taged (localhost:5000/mycentos8) and pushed to local registry.  
 d) The content was added to the file /etc/docker/daemon.json (to enable insecure registry option): { "insecure-registries" : [ "localhost:5000" ] }

## 2) Main stage:
 a) The role was created (adding httpd, sending index.html).  
 b) Testinfra was choosen for tests.  
 c) Two tests are located in 'molecule/default/tests/test_default.py' ('Checking if the package is installed', 'Checking that file exists and contains the content').
