# Project-G

## Scenario 1 - Terraform, AWS, CICD

In this deployment Terraform deploys highly available auto-scaling group of 3 AWS EC2s (Server fleet A, t2.micro instance type) running nginx to serve public web content, behind a public ALB in the Singapore region. The EC2 servers when booting up will download the web content from a private S3 bucket.

![Optional Text](./Infrastructure%20Setup.png)

## 1. Terraform Deployment - AWS Infrastructure Setup
These instructions for setting up Terraform on your local development environment and deploying the infrastructure using Terraform.

## Prerequisites

Before you begin, make sure you have the following installed on your laptop:

1. **Terraform**: Install Terraform on your machine. You can download the latest version (**required_version = ">= 1.2.0"**) from the official website: [Terraform Downloads](https://www.terraform.io/downloads.html).

2. **Git**: Ensure you have Git installed to clone the project repository. You can download Git from [here](https://git-scm.com/downloads).

3. **AWS Account**: Sign up for an account with your AWS Account where you want to deploy the infrastructure. Make sure you have the necessary credentials (access keys, tokens, etc.) to authenticate with your AWS Account. Since the IaC code included to provision the VPC,IAM roles and Application services(ec2,alb,asg), the required permissions are needed.

4. **Text Editor or IDE(Visual Studio Code)**: Choose a text editor or integrated development environment (IDE) of your choice. Popular options include Visual Studio Code.

## Getting Started

Follow the steps below to set up the Terraform project and deploy the infrastructure:

1. **Clone the Repository**: Clone the project repository to your local machine using Git. Open your **Git Bash terminal** or command prompt and run the following command:

   ```bash
    git clone https://gitlab.com/nagajyothi0207/project-g.git
    cd project-g
    git branch -M master
   ```

2. **Configure AWS Credentials**: Set up the necessary credentials for your AWS Account. For example, if you are using AWS, configure your AWS access keys and secret access keys using the AWS CLI or environment variables. Refer to the documentation for detailed instructions [AWS CLI Installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions) and [iam user with static credential](https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html)

3.  **[OPTIONAL - if you want to avoid running terraform commands]** The shell script will help to your run the Terraform workflow. 
    ```bash
    sh setup.sh
    ```

4. **Initialize Terraform**: The shell script will help to your run the Terraform workflow. 
Change into the cloned repository directory and initialize Terraform. This will download the required plugins for your provider.

   ```bash
   terraform init
   ```

5. **Review and Modify Configuration**: Inspect the Terraform configuration files (usually with `.tf` extension) in the repository. Make any necessary adjustments to suit your specific requirements, such as changing resource names, regions, or instance types.

6. **Plan the Deployment**: Run the Terraform plan command to see the execution plan without actually deploying the infrastructure. This step will show you what resources Terraform intends to create.

   ```bash
   terraform plan -out myplan
   ```

7. **Deploy the Infrastructure**: If the plan looks good, you can proceed with the actual deployment. Execute the Terraform apply command to create the infrastructure:

   ```bash
   terraform apply myplan
   ```

Terraform will print the provisioned Resources outputs.


## 2. Gitlab CI Setup for Code change deployments
### Prerequisites
1. gitlab CICD environment variables configuration


























## Clean Up the resources


8. **Destroy the Infrastructure (Optional)**: If you want to tear down the infrastructure and remove all resources, you can use the Terraform destroy command:

   ```bash
   terraform destroy
   ```

   **Note:** Be cautious when using `terraform destroy` as it will permanently delete all resources created by Terraform.

## Conclusion

Using AWS Static Credentials (Access Key and Secrets Access Key) is not a best practice. Remember to follow the AWS best practices, version control your Terraform code, and be cautious while performing deployments and destroy actions. Happy Terraforming! 🚀

