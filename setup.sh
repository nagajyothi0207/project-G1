#!/bin/bash
echo ""
#rm -rf terraform.tfvars
terraform fmt
terraform validate
echo "#Terraform inputs" >terraform.tfvars
echo ""

# Getting the default vpc id and setting env variables for terraform
vpc_id=`aws ec2 describe-vpcs --filter Name=isDefault,Values=true --query Vpcs[0].VpcId --region ap-southeast-1`
export TF_VAR_vpc_id=$vpc_id
echo "vpc_id = "$vpc_id"" >>terraform.tfvars
# echo "printing the vpc id from env"
env | grep vpc_id

echo "get the default prublic subnets and delete"
##get the default prublic subnets and delete
#subnets=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=${vpc_id} --output text --query 'Subnets[].SubnetId' )
#  if [ "${subnets}" != "None" ]; then
#    for subnet in ${subnets}; do
#      echo "${INDENT}Deleting subnet ${subnet}"
#      aws ec2 delete-subnet --subnet-id ${subnet}
#    done
#  fi
#
# Get the public IP for accessing the public subnet resources
public_ip=`curl ifconfig.co`
#export TF_VAR_myip=${public_ip}/32
public_ip_restriction=\"${public_ip}/32\"
echo "myip = " $public_ip_restriction" " >>terraform.tfvars


#terraform init 
#terraform plan -out myplan
#terraform apply myplan