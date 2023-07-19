data "archive_file" "recursive-lambda" {
  type        = "zip"
  source_dir  = "recursive-lambda"
  output_path = "recursive-lambda.zip"
}

