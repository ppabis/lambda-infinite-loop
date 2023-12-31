data "archive_file" "recursive-lambda" {
  type        = "zip"
  source_dir  = "recursive-lambda"
  output_path = "recursive-lambda.zip"
}

resource "aws_lambda_function" "recursive-function" {
  function_name    = "recursive-function"
  role             = aws_iam_role.lambda-role.arn # Attach role
  handler          = "main.handler"               # File: main.py, function: handler
  runtime          = "python3.8"
  filename         = data.archive_file.recursive-lambda.output_path
  source_code_hash = data.archive_file.recursive-lambda.output_base64sha256
  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.queue.id
    }
  }
}

resource "aws_lambda_event_source_mapping" "recursive-function" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = aws_lambda_function.recursive-function.function_name
  batch_size       = 1
}

resource "aws_lambda_event_source_mapping" "recursive-function-dlq" {
  event_source_arn = aws_sqs_queue.dead-letter-queue.arn
  function_name    = aws_lambda_function.recursive-function.function_name
  batch_size       = 1
}