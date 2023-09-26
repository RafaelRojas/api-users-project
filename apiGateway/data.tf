data "terraform_remote_state" "createUserlambda" {
  backend = "local"

  config = {
    path = "../lambda/createUser/terraform.tfstate"
  }
}

data "terraform_remote_state" "deleteUserlambda" {
  backend = "local"

  config = {
    path = "../lambda/deleteUser/terraform.tfstate"
  }
}

data "terraform_remote_state" "listUserslambda" {
  backend = "local"

  config = {
    path = "../lambda/listUsers/terraform.tfstate"
  }
}

data "terraform_remote_state" "modifyUserlambda" {
  backend = "local"

  config = {
    path = "../lambda/modifyUser/terraform.tfstate"
  }
}

data "terraform_remote_state" "iam" {
  backend = "local"

  config = {
    path = "../iam/terraform.tfstate"
  }
}