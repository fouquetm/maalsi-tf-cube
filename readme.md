terraform init -backend-config="backend.tfvars"
terraform plan -out="myplan.plan" ou terraform plan -var-file="./env/my-var-file.tfvars" -out="myplan.plan"
terraform apply myplan.plan

az account set --subscription subscriptionId
az aks get-credentials --resource-group rgName --name clusterName --overwrite-existing

kubectl create ns myNamespace
kubectl apply -f aks-store-quickstart.yaml -n myNamespace

