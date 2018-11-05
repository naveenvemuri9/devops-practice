Build and Deploy GO-APP on eks cluster[CI/CD e2e]
=================================

This project implements playbooks to provision and configure GO-APP on eks. This project is WORK IN PROGRESS.

Main goals
----------
- Create, Deploy, Delete environments for GO-APP
- Install GO-APP on any k8s eks cluster
- Expose GO-APP on load balancer and enable autoscaling

Setup CI system
-----------------------
- Get the Jenkins server up and running with required plugins 
- Get the worker node with following dependencies and add to Jenkins master:
```
- Java jdk 
- ansible 
- awscli 
- Kubectl 
- iam-authenticator
- Docker
- Python, Pip
```

Infrastructure Provisoning from command line:
---------------------------------------------
- Give the required credentials in dockerfile.
- Build and push the docker images for go-app,terraform to docker registry.

1. Provison Eks cluster
-----------------------
- Create a eks cluster with the following commands
```
$ ansible-playbook eks_provision_cluster.yaml --extra-vars "cluster_name=YOUR_CLUSTER_NAME"
```
Use this VAULT_PASSWORD path in following commands to create AppCenter Environment.

2. Destroy K8s cluster
------------------------
- To destroy K8s cluster
```
$ ansible-playbook destroy_cluster.yaml --extra-vars "cluster_name=YOUR_CLUSTER_NAME"
```

Application Deployment:
-----------------------
1. Deploy GO-APP on eks cluster
----------------------------
- For deploying go-app to k8s cluster
```
$ ansible-playbook deployment.yaml --extra-vars "cluster_name=YOUR_CLUSTER_NAME"
```
2. Uninstall GO-APP 
- To uninstall go-app
```
$ ansible-playbook unintall-go-app.yaml
```