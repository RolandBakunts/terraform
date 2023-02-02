variable "aws_region" {    
    type = string
    default = "us-east-1"
}

variable "cidr-block-vpc" {
    type = string
	default = "10.20.0.0/16"
}

variable "cidr-block-pb-subnet" {
    type = list
	default = ["10.20.5.0/24", "10.20.2.0/24", "10.20.3.0/24"]
}     

variable "azs" {
	type = list
	default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "cidr-block-route_tb" {
    type = string
    default = "0.0.0.0/0"
}

variable "name-tag" {
    type = string
    default = "_YVN"
}

variable "owner-tag" {
    type = string
    default = "rbakunts"
}

variable "project-tag" {
    type = string
    default = "2023_internship_YVN"
}

variable "instance-type" {
    type = string
    default = "t2.micro"
}

variable "instance_count" {
  default = "3"
}
