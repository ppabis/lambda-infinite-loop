resource "aws_sqs_queue" "queue" {
  name = "recursive-queue"
  message_retention_seconds = 120
}