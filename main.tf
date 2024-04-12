resource "aws_lambda_function" "IPChecker" {
  function_name = var.function_name
  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"
  filename = var.filename
  source_code_hash = filebase64sha256(var.filename)
  role = aws_iam_role.IAMRole.arn
  timeout = var.timeout
  memory_size = var.memory_size

}

#createa aiam role for the above function and assing lambda excution role and acess to decribe and update managed prefix lsit 

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

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

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_vpc_prefixlist_policy"
  description = "Policy to allow Lambda to read and update managed prefix lists in VPCs"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeManagedPrefixLists",
          "ec2:ModifyManagedPrefixList"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
