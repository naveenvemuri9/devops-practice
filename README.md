Build and Deploy GO-APP on eks cluster [CI/CD E2E]
================================================

This project implements playbooks to provision and configure GO-APP on eks. This project is WORK IN PROGRESS.

Main goals
----------
- Create, Deploy, Delete environments for GO-APP
- Install GO-APP on any k8s eks cluster
- Expose GO-APP on load balancer and enable autoscaling

Setup CI system
-----------------------
- Get the Jenkins server up and running with required plugins 
- Get the worker node with following dependencies and add to Jenkins master
- Add the Github and Dockerhub credentials in Jenkins configure credentials.
```
#- Worker node Installations and Paths
- Java jdk 
- ansible 
- awscli 
- Kubectl 
- iam-authenticator
- Docker
- Python, Pip
- pip install docker-py
- pip install awscli --ignore-installed six
- awsconfigure
```
-  Notes: export variables for aws, export paths for iam-autneticator, kubectl.

#-  This steps can be automated in future development using ansible.   

Refer this links to install the dependencies on worker-node
-------------------------------------------------------------
- Refer this document in setting up worker node for jenkins for iam and kubectl.
* https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html
* https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html

Run pipeline from Jenkins:
---------------------------
- Once setup was done with master and worker, Create a multibranch pipeline in new item
- And give the required configuration for multi-branch pipeline
- If required change the Jenkinsfile dockerhub credentials id. 
- After configuration go to build project and select the build parameters which ever you like to todo.

Infrastructure Provisoning from command line:
---------------------------------------------
- Give the required credentials in dockerfile.
- Build and push the docker images for go-app,terraform to docker registry.
1. Create the terraform Image
------------------------------
- After cloning this repository build the docker image from Dockerfile in current respoitory with changing the aws credentials or you can put in variables calling from jenkins.
- This image is for Terraform has we are running the terraform in a container.
```
$ docker build -t IMAGE_NAME .
```
2. Tag the image and push to docker hub
----------------------------------------
```
$ docker tag IMAGE_ID YOUR_REPO/IMAGE_NAME:TAG
$ docker push YOUR_REPO/IMAGE_NAME:TAG
```

3. Provison Eks cluster
-----------------------
- Create a eks cluster with the following commands
```
$ ansible-playbook eks_provision_cluster.yaml --extra-vars "cluster_name=YOUR_CLUSTER_NAME"
```

4. Destroy K8s cluster
------------------------
- To destroy K8s cluster
```
$ ansible-playbook destroy_cluster.yaml --extra-vars "cluster_name=YOUR_CLUSTER_NAME"
```

Application Deployment:
-----------------------
1. Deploy GO-APP on eks cluster
----------------------------
- Deployment yaml file will deploy application on to kubernetes cluster
- For deploying go-app to k8s cluster
```
$ ansible-playbook deployment.yaml --extra-vars "cluster_name=YOUR_CLUSTER_NAME"
```
2. Uninstall GO-APP 
- To uninstall go-app
```
$ ansible-playbook unintall-go-app.yaml
```

Access the application:
-----------------------
- Get the load balancer DNS name and added it to route53 by creating the recordsets(This can be automatesd through ansible when deploying application)
- To access the app
```
dns_name/book
```
or
```
domain/books
```
- It will show the json output
- To access the users
```
domain/books/1 or domain/books/2
```

Future Developemnt to application
----------------------------------
1. Maintain the Version file in repo, BY this we can version the application image.
2. Automate the worker node setup using ansible
3. Automate adding the dns entrys for application to run on domain name etc.
