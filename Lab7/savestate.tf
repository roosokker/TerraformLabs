terraform {
  backend "s3" {
    bucket         = "rodainabucket"
    key            = "Rodaina/terraform.tfstate"
    region         = "us-east-1"
  }
}