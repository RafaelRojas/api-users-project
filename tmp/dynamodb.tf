resource "aws_dynamodb_table" "users" {
  name           = "users"
  billing_mode   = "PROVISIONED"  # You can also use "PAY_PER_REQUEST" for on-demand billing
  read_capacity  = 5               # Adjust as needed
  write_capacity = 5               # Adjust as needed
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"  # Numeric attribute type for 'id'
  }
}
