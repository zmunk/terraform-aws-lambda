locals {
  filename = data.external.archive_prepare.result.filename
}

resource "aws_lambda_function" "this" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function

  function_name = var.function_name
  description   = var.description
  role          = aws_iam_role.lambda.arn
  handler       = var.handler
  runtime       = var.runtime
  layers        = var.layers
  timeout       = var.timeout
  filename      = local.filename

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  depends_on = [
    null_resource.archive,
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy_attachment.additional_json,
    aws_iam_role_policy_attachment.logs,
  ]
}
