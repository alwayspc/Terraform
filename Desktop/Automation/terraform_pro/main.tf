provider "aws" {
    region = "ap-south-1"
}

module "vpc" {
    source = "./modules/vpc"
    region = "ap-south-1"
    
}