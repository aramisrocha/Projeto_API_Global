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



# Zip do código Python


data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/api_bitcoin_price.py"
  output_path = "${path.module}/api_bitcoin_price.zip"
}



# Lambda 1 na região primária
resource "aws_lambda_function" "api_bitcoin_primary_1" {
  provider = aws.primary

  function_name = "api-bitcoin-price-primary-1"
  filename      = data.archive_file.lambda_zip.output_path
  handler       = "api_bitcoin_price.lambda_handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_exec.arn

  vpc_config {
    subnet_ids         = [module.network_primary.subnet_ids[0]]   # ajuste para a output real do módulo
    security_group_ids = [aws_security_group.lambda_primary_sg.id]
  }
}

# Lambda 2 na região primária
resource "aws_lambda_function" "api_bitcoin_primary_2" {
  provider = aws.primary

  function_name = "api-bitcoin-price-primary-2"
  filename      = data.archive_file.lambda_zip.output_path
  handler       = "api_bitcoin_price.lambda_handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_exec.arn

  vpc_config {
    subnet_ids         = [module.network_primary.subnet_ids[0]]
    security_group_ids = [aws_security_group.lambda_primary_sg.id]
  }
}



# Lambda 1 na região secundária
resource "aws_lambda_function" "api_bitcoin_secondary_1" {
  provider = aws.secondary

  function_name = "api-bitcoin-price-secondary-1"
  filename      = data.archive_file.lambda_zip.output_path
  handler       = "api_bitcoin_price.lambda_handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_exec.arn

  vpc_config {
    subnet_ids         = [module.network_secondary.subnet_ids[0]]
    security_group_ids = [aws_security_group.lambda_secondary_sg.id]
  }
}

# Lambda 2 na região secundária
resource "aws_lambda_function" "api_bitcoin_secondary_2" {
  provider = aws.secondary

  function_name = "api-bitcoin-price-secondary-2"
  filename      = data.archive_file.lambda_zip.output_path
  handler       = "api_bitcoin_price.lambda_handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_exec.arn

  vpc_config {
    subnet_ids         = [module.network_secondary.subnet_ids[0]]
    security_group_ids = [aws_security_group.lambda_secondary_sg.id]
  }
}
