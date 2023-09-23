resource "aws_iam_role" "lambda_role" {
  name = "lambdaRole"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        },
        {
        "Effect": "Allow",
        "Principal": {
          "Service": "apigateway.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_dynamo_logs_policy" {
  name        = "lambdaDynamoLogsPolicy"
  description = "execution role for the Lambda function"

  # The JSON policy document
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "lmbgwplc01",
        Action = [
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem",
        ],
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Sid       = "",
        Resource  = "*",
        Action    = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Effect    = "Allow",
      },
    ],
  })
}

resource "aws_iam_policy_attachment" "lambda_policy_attach" {
  name       = "lambdaPolicyAttach"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_dynamo_logs_policy.arn
}

resource "aws_iam_role" "api_gateway_execution_role" {
  name = "APIGatewayExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "apigateway.amazonaws.com"
      }
    }]
  })
}











###SUggested solution for lambda execution role for apigw
# not yet
# resource "aws_iam_role" "lambda_execution_role_4_apigw" {
#   name = "LambdaExecutionRole4apigateway"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }















# resource "aws_iam_policy_attachment" "lambda_dynamodb_policy" {
#   name        = "MyLambdaDynamoDBPolicyAttachment"
#   policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
#   roles       = [aws_iam_role.lambda_role.name]
# }


# #agw test execution role
# # Define the IAM role for API Gateway to invoke Lambda
# resource "aws_iam_role" "api_gateway_execution_role" {
#   name = "APIGatewayExecutionRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action = "sts:AssumeRole",
#       Effect = "Allow",
#       Principal = {
#         Service = "apigateway.amazonaws.com"
#       }
#     }]
#   })
# }

# # Attach the necessary policy to the IAM role
# # This policy should allow API Gateway to invoke Lambda functions
# resource "aws_iam_policy_attachment" "api_gateway_execution_policy" {
#   name        = "APIGatewayExecutionPolicyAttachment"
#   policy_arn  = "arn:aws:iam::aws:policy/AWSLambdaExecute"
#   roles       = [aws_iam_role.api_gateway_execution_role.name]
# }
# resource "aws_iam_policy_attachment" "api_gateway_log_policy" {
#   name        = "APIGatewayCloudwatchPolicyAttachment"
#   policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
#   roles       = [aws_iam_role.api_gateway_execution_role.name]
# }

# #create policy to inkove lambda
# resource "aws_iam_policy" "lambda_invoke_policy" {
#   name        = "LambdaInvokePolicy"
#   description = "Policy to allow API Gateway to invoke Lambda functions"
  
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "lambda:InvokeFunction",
#         Effect = "Allow",
#         Resource = aws_lambda_function.crud_lambda.invoke_arn
#       }
#     ]
#   })
# }

# ##attach the policy
# resource "aws_iam_policy_attachment" "lambda_invoke_attachment" {
#   name       = "APIGatewayLambdaInvokeAttachment"
#   policy_arn = aws_iam_policy.lambda_invoke_policy.arn
#   roles      = [aws_iam_role.api_gateway_execution_role.name]
# }



# # output "lambda_role" {
# #   value = aws_iam_role.lambda_role.arn
# # }

# # output "aws_iam_policy_lambda_dynamo_logs_policy" {
# #   value = aws_iam_policy.lambda_dynamo_logs_policy.arn
# # }

