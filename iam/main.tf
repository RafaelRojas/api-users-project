resource "aws_iam_role" "UsersLambdaRole" {
  name               = "UsersLambdaRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "UsersLambdaPolicy" {
  name        = "UsersLambdaPolicy"
  description = "Policy for API Gateway Execution Role"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:ListTables",
          "dynamodb:UpdateItem"
        ],
        "Resource" : "arn:aws:dynamodb:*:*:table/users"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "UsersLambdaRolePolicy" {
  role       = aws_iam_role.UsersLambdaRole.name
  policy_arn = aws_iam_policy.UsersLambdaPolicy.arn
}