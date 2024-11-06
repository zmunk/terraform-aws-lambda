resource "aws_iam_role" "lambda" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

  name = var.function_name
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_policy" "logs" {
  name = "${var.function_name}-logs"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "logs:PutLogEvents",
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
          ]
          Effect = "Allow"
          Resource = [
            "${aws_cloudwatch_log_group.lambda.arn}:*",
            "${aws_cloudwatch_log_group.lambda.arn}:*:*",
          ]
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.logs.arn
}

resource "aws_iam_policy" "additional_json" {
  count = var.policy_json != null ? 1 : 0

  name   = var.function_name
  policy = var.policy_json
}

resource "aws_iam_role_policy_attachment" "additional_json" {
  count = var.policy_json != null ? 1 : 0

  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.additional_json[0].arn
}

##############
# Cloudwatch #
##############

resource "aws_cloudwatch_log_group" "lambda" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
  name = "/aws/lambda/${var.function_name}"
}

