output "arn" {
  description = "The ARN of the Lambda Function"
  value       = try(aws_lambda_function.this.arn, "")
}

output "function_name" {
  description = "The name of the Lambda Function"
  value       = aws_lambda_function.this.function_name
}

output "invoke_arn" {
  description = "The invoke arn of the Lambda Function"
  value       = aws_lambda_function.this.invoke_arn
}

output "log_group_name" {
  description = "The CloudWatch log group name of the Lambda Function"
  value       = aws_cloudwatch_log_group.lambda.name
}
