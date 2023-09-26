data "terraform_remote_state" "dynamo" {
  backend = "local"

  config = {
    path = "../../dynamo/terraform.tfstate"
  }
}

data "terraform_remote_state" "iam" {
  backend = "local"

  config = {
    path = "../../iam/terraform.tfstate"
  }
}