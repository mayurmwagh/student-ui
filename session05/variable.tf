variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}
variable "instance_id" {
  type    = string
  default = "ami-0cff7528ff583bf9a"
}

variable "availability_zone" {
  type = string
  default     = "us-east-1c"
}

variable "associate_public_ip_address" {
  type    = bool
  default = true
}


variable "vpc-tags" {

    type = string
    default = "vpc-11"

}

variable "cidr_block-pub" {

    type = map(string)
    default = {
        
        pub0 = "10.0.0.0/24"
        pub1 = "10.0.1.0/24"
    }
}

variable "cidr_block-pri" {
    type = map(string)
    default = {
        
        pri0 = "10.0.2.0/24"
        pri1 = "10.0.3.0/24"
        pri2 = "10.0.4.0/24"
    }
}

variable "namespace" {
    type = string
    default = "cloud"
}

locals {
  ingress_rules = [{
    port        = 22
    description = "this is ssh port"
    },
    {
      port        = 443
      description = "this is https port"
    },
    {
      port        = 80
      description = "this is http port"
  }]

}