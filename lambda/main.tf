provider "aws" {
  region = "us-east-1"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./index.mjs"
  output_path = "./index.zip"
}

resource "aws_lambda_function" "crud_lambda" {
  # depends_on = [
  #   aws_iam_policy.lambda_dynamo_logs_policy,
  #   aws_iam_role.lambda_role ]
  function_name = "CRUDLambda"
  handler      = "index.handler"
  runtime      = "nodejs18.x"
  role         = data.terraform_remote_state.iam.outputs.lambda_role
  filename     = "./index.zip"
}

#Logging for LAMBDA
resource "aws_cloudwatch_log_group" "api_crud_cwlg" {
  name = "/aws/lambda/${aws_lambda_function.crud_lambda.function_name}"

  retention_in_days = 30
}
