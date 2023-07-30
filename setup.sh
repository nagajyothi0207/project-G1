#!/bin/bash
AWS_REGION="ap-southeast-1"
echo "this script helps to bootstrap the project deployment resources on Default VPC"
#rm -rf terraform.tfvars
terraform init
terraform fmt
terraform validate
echo "#Terraform inputs" >terraform.tfvars
echo ""

#aws ec2 describe-vpcs --region $AWS_REGION --query 'Vpcs[?(IsDefault==`true`)].VpcId | []'
#if [ $? -eq 0 ]
#then
#      echo "No Default VPC Available for this assessment - Proceeding to create a Default VPC"
#      aws ec2 create-default-vpc --region $AWS_REGION 
#else
#       echo "default vpc found and proceeding to remove the default subnets, before creating secured micro segment"
#fi
#
## Getting the default vpc id and setting env variables for terraform
#vpc_id=`aws ec2 describe-vpcs --filter Name=isDefault,Values=true --query Vpcs[0].VpcId --region $AWS_REGION`
#export TF_VAR_vpc_id=$vpc_id
#echo "vpc_id = "$vpc_id"" >>terraform.tfvars
## echo "printing the vpc id from env"
#env | grep vpc_id

#echo "get the default prublic subnets and delete"
##get the default prublic subnets and delete
#subnets=$(aws ec2 describe-subnets --filters 'Name=default-for-az,Values=true' --output text --query 'Subnets[].SubnetId' )
#  if [ "${subnets}" != "None" ]; then
#    for subnet in ${subnets}; do
#      echo "${INDENT}Deleting subnet ${subnet}"
#      aws ec2 delete-subnet --subnet-id ${subnet}
#    done
#  fi

# Get the public IP for accessing the public subnet resources
public_ip=`curl ifconfig.co`
#export TF_VAR_myip=${public_ip}/32
public_ip_restriction=\"${public_ip}/32\"
echo "myip = " $public_ip_restriction" " >>terraform.tfvars
echo "vpc_cidr = \"172.31.0.0/16"\" >>terraform.tfvars

terraform init 
terraform plan -out myplan
terraform apply myplan