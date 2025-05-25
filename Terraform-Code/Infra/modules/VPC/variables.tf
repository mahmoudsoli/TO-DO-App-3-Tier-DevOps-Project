variable "vpc_cidr" {
  description = "value of the VPC CIDR block"
  type        = string
}

variable "cluster_name" {
  description = "name of the cluster"
  type        = string
  default     = "otel-cluster"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "az_for_private_subnet" {
  description = "availability zones for private subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "az_for_public_subnet" {
  description = "availability zones for public subnets"
  type        = list(string)
}