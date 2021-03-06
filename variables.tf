variable "tf_aws_access_key" {
  description = "AWS access key."
}

variable "tf_aws_secret_key" {
  description = "AWS secret key."
}

variable "jenkinsslave_aws_ecr_access_key" {
  description = "AWS ECR access key."
}

variable "jenkinsslave_aws_ecr_secret_key" {
  description = "AWS ECR secret key."
}

variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-central-1"
}

variable "key_name" {
  description = "Name of the keypair to use in EC2."
  default     = "awsxebia_demo"
}

variable "public_key_path" {
  default = "keys/awsxebia.pub"
}

variable "private_key_path" {
  default = "keys/awsxebia.pem"
}

#Ubuntu 14.04 LTS
variable "aws_amis" {
  description = "Chef, Jekins Master,  Jenkins Slave"

  default = {
    #us-west-2 = "ami-01f05461" # Ubuntu 14.04
    eu-central-1 = "ami-8504fdea"
  }
}

variable "instance_type" {
  # default = "t2.medium"
  default = "c3.2xlarge"
}

# variable "availability_zones" {
#   type="list"
#   description = "The availability zones"
#   default     = ["eu-west-2a,eu-west-2b,eu-west-2c"]
# }

variable "aws_ecr_repository" {
  description = "AWS ECR Repository Name"
  default     = "jenkins_demo"
}

variable "jenkinsslave_count" {
  default = "1"
}

variable "jenkinsmaster_port" {
  default = "8080"
}

variable "jenkinsmaster_allowed_ips" {
  default = ["110.172.135.78/32", "110.172.135.79/32"]
}

variable "chef_version" {
  default = "12.15.19"

  #server  = "NOT_USED"
  client = "12.15.19"
}

variable "chef_admin_key_path" {
  default = "./keys/xebiadev.pem"
}

variable "chef_organization_name" {
  default = "devtool"
}

variable "chef_env_name" {
  default = "_default"
}

variable "chef_server_name" {
  default = "chefserver"
}

variable "chef_server_public_ip" {
  default = "35.163.78.214"
}

variable "chef_user_name" {
  default = "xebiadev"
}
