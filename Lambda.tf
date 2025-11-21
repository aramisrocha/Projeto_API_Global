# IAM Role para as Lambdas
############################

# Trust policy para Lambda assumir a role
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Role única, criada usando o provider padrão (não importa região, IAM é global)
resource "aws_iam_role" "lambda_exec" {
  name               = "lambda-exec-api-bitcoin-price"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Anexa a policy básica da Lambda (logs no CloudWatch)
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


############################
# Zip do código Python
############################

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/api_bitcoin_price.py"
  output_path = "${path.module}/api_bitcoin_price.zip"
}