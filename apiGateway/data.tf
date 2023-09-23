data "terraform_remote_state" "lambda" {
  backend = "local"

  config = {
    path = "../lambda/terraform.tfstate"
  }
}

data "terraform_remote_state" "iam" {
  backend = "local"

  config = {
    path = "../iam/terraform.tfstate"
  }
}