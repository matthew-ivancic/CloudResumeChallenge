resource "aws_api_gateway_rest_api" "crc_api" {
  name        = "CloudResumeChallenge"
  description = "API to call the Lambda function for the Cloud Resume Challenge"
}

resource "aws_api_gateway_resource" "crc_api" {
  rest_api_id = aws_api_gateway_rest_api.crc_api.id
  parent_id   = aws_api_gateway_rest_api.crc_api.root_resource_id
  path_part   = "CloudResumeChallenge"
}

resource "aws_api_gateway_method" "options" {
  rest_api_id   = aws_api_gateway_rest_api.crc_api.id
  resource_id   = aws_api_gateway_resource.crc_api.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options" {
  rest_api_id = aws_api_gateway_rest_api.crc_api.id
  resource_id = aws_api_gateway_resource.crc_api.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = 200
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.options]
}

resource "aws_api_gateway_integration" "options" {
  rest_api_id = aws_api_gateway_rest_api.crc_api.id
  resource_id = aws_api_gateway_resource.crc_api.id
  http_method = aws_api_gateway_method.options.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" : "{\"statusCode\": 200}"
  }
  passthrough_behavior = "WHEN_NO_MATCH"
  depends_on           = [aws_api_gateway_method.options]
}

resource "aws_api_gateway_integration_response" "options" {
  rest_api_id = aws_api_gateway_rest_api.crc_api.id
  resource_id = aws_api_gateway_resource.crc_api.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.options]
}

resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.crc_api.id
  resource_id   = aws_api_gateway_resource.crc_api.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "post" {
  rest_api_id = aws_api_gateway_rest_api.crc_api.id
  resource_id = aws_api_gateway_resource.crc_api.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = 200
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  depends_on = [aws_api_gateway_method.post]
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.crc_api.id
  resource_id             = aws_api_gateway_resource.crc_api.id
  http_method             = "POST"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.viewCountIncrement.invoke_arn
  depends_on              = [aws_api_gateway_method.post, aws_lambda_function.viewCountIncrement]
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.crc_api.id
  stage_name  = "prod"
  depends_on  = [aws_api_gateway_integration.integration]
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.viewCountIncrement.arn
  principal     = "apigateway.amazonaws.com"
}
