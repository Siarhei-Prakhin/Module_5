# Short workflow of DevOPS practical task №9

## Main plan
From the host machines will be created **3 VMs** (main, swarm_1, swarm_2) (see "for_host" directory).  
a) On main machine the local registry will be started in container. Some different versions of **NGINX** images will be loaded to it.  
b) Insecure registry will be enabled on all of these machines.  
c) On main machine Jenkins will start the new item, that will use extended parameter choice (from NGINX versions in local registry) to build new Docker image and push it to local registry.  
d) Then ansible playbook2 will be started - it will make docker swarm cluster on these 3 machines and deploy service to it (previously the first free port from range 8080 and bigger will be found and used).  

P.s. If I'll try to write in details - it will be too big Readme file. May be I'll explain and show it on meeting.
