provider "aws" {
  region = "us-east-1"
  profile = "gh"
}


resource "aws_lambda_function" "epam_query" {
  function_name = "EpamQuery"
  s3_bucket = var.s3_bucket
  s3_key = "v1/mape-lambda.zip"
  handler = "main.handler"
  runtime = "python3.7"
  role = aws_iam_role.epam_query_lambda.arn
  tags = {
    "terraform" = true
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.epam_query.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.epam_api.execution_arn}/*/*"
}

resource "aws_iam_role" "epam_query_lambda" {
  name = "epam_query_lambda"
  tags = {
    "terraform" = true
  }
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
