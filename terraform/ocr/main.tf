terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.42.0"
    }
  }
 
  required_version = ">= 1.3.5"

}    

provider "aws" {
     region   = local.common.tags.region # Defined in config.json
}