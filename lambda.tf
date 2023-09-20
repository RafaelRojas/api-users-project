data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./index.mjs"
  output_path = "./index.zip"
}

resource "aws_lambda_function" "crud_lambda" {
  depends_on = [
    aws_iam_policy.lambda_dynamo_logs_policy,
    aws_iam_role.lambda_role ]
  function_name = "CRUDLambda"
  handler      = "index.handler"
  runtime      = "nodejs18.x"
  role         = aws_iam_role.lambda_role.arn
  filename     = "./index.zip"
}
