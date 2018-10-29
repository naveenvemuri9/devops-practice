# Go Application Deploy on AWS using terraform and ansible on Jenkins

## In Linux machine (local):
1. Create new SSH keyfile if you dont have any using following command,

$ ssh-keygen -f test.pem  (if you are changing this name, mention in terraform/variables.tf)
$ cp test.pem terraform/

## In Jenkins:
2. Create new job with the repo in SCM (mention the repo link in GIT)

3. Create execute shell with following commands

yum install epel-release -y

yum install jq -y

cd terraform

terraform init

terraform plan

terraform apply -auto-approve

hosts=$(terraform output -json instance_ips | jq .value[0] | sed 's/"//g')

4. Then create the Invoke ansible playbook

playbook path = deployment.yml
inline content = $hosts

in credentials give the new server username(default=ubuntu) and keyfile(which you create step1)

Note: Before run the playbook dont forgot to mention the dockerhub username and password deployment.yml
