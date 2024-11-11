# AWS Lambda Terraform module

Terraform module, to build and package AWS Lambda resources from local files.

See https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest.

## Usage
```terraform
resource "aws_lambda_function" "websocket_connect" {
  source  = "zmunk/lambda/aws"
  version = "~> 1.0.0"

  function_name = "websocket_connect"
  description   = "Runs when a new client connects to websocket"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  source_path   = "lambda/websocket_connect"

  # Optionally, add environment variables
  environment_variables = {
    DB_TABLE = aws_dynamodb_table.books.arn
  }

  # Optionally, attach lambda layers
  layers = [
    module.jinja_lambda_layer.arn
  ]

  # Optionally, add permissions
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "dynamodb:Query"
        Resource = "${aws_dynamodb_table.books.arn}/index/*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem",
        ]
        Resource = aws_dynamodb_table.books.arn
      },
    ]
  })
}
```
