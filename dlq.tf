resource "aws_sqs_queue" "dead-letter-queue" {
  name = "recursive-dead-letter-queue"
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.queue.arn]
  })
}

resource "aws_sqs_queue_redrive_policy" "redrive-policy" {
  queue_url = aws_sqs_queue.queue.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead-letter-queue.arn
    maxReceiveCount     = 1 # Redrive immediately
  })
}