resource "aws_iam_role" "lambda-role" {
  name = "recursive-lambda-role"
  assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [ {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = { Service = "lambda.amazonaws.com" }
        } ]
    })
}

data "aws_iam_policy_document" "sqs" {
  statement {
    effect = "Allow"
    resources = [ 
      aws_sqs_queue.queue.arn,
      aws_sqs_queue.dead-letter-queue.arn
    ]
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
  }
}

resource "aws_iam_policy" "sqs" {
  name = "AllowSQSBasicActions"
  policy = data.aws_iam_policy_document.sqs.json
}

resource "aws_iam_role_policy_attachment" "lambda-sqs" {
  role = aws_iam_role.lambda-role.name
  policy_arn = aws_iam_policy.sqs.arn
}

resource "aws_iam_role_policy_attachment" "basic-execution-role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.lambda-role.name
}