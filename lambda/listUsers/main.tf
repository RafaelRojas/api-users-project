
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./list_users_lambda.py"
  output_path = "./list_users_lambda.zip"
}

resource "aws_lambda_function" "ListUsersHandler" {
  function_name = "ListUsersHandler"
  filename = "./list_users_lambda.zip"
  handler = "list_users_lambda.lambda_handler"
  runtime = "python3.10"
  environment {
    variables = {
      REGION        = "us-east-1"
      USERS_TABLE = data.terraform_remote_state.dynamo.outputs.dynamo_table_name
   }
  }
  #source_code_hash = filebase64sha256("./users_lambda.zip")
  role =  data.terraform_remote_state.iam.outputs.users_lambda_role_arn
  timeout     = "35"
  memory_size = "128"
}

#Logging for LAMBDA
resource "aws_cloudwatch_log_group" "usersLambda" {
  name = "/aws/lambda/${aws_lambda_function.ListUsersHandler.function_name}"

  retention_in_days = 5
}
