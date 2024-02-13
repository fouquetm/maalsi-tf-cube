terraform init -backend-config="backend.tfvars"
terraform plan -out="myplan.plan" ou terraform plan -var-file="./env/my-var-file.tfvars" -out="myplan.plan"
terraform apply myplan.plan