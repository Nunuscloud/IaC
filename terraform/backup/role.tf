resource "aws_iam_instance_profile" "instance_profile" {
  name = "administrator_access_profile"
  role = aws_iam_role.administrator_access_role.name
}

resource "aws_iam_role_policy_attachment" "admin_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.administrator_access_role.name
}

resource "aws_iam_role" "administrator_access_role" {
  name = "administrator_access_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
