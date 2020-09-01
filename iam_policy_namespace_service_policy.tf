data "aws_iam_policy_document" "namespace_service_policy_document" {
  statement {
    actions = [
      "ec2:CreateTags",
      "logs:CreateLogGroup",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
    ]

    resources = [
      "arn:aws:kms:*:${var.account_id}:key/${var.namespace}/*",
    ]
  }

  statement {
    actions = [
      "sns:Publish",
    ]

    resources = [
      "arn:aws:sns:*:${var.account_id}:${local.sns_prefix}*",
    ]
  }

  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
    ]

    resources = [
      "arn:aws:sqs:*:${var.account_id}:${local.queue_prefix}*",
    ]
  }

  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]

    resources = [
      "arn:aws:secretsmanager:*:${var.account_id}:secret:${local.prefix}/${local.namespace}/*",
    ]
  }

  statement {
    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:*:${var.account_id}:parameter:${local.prefix}/${local.namespace}/*",
    ]
  }
}

resource "aws_iam_policy" "namespace_service_policy" {
  name   = "${local.policy_path}service-policy"
  policy = "${data.aws_iam_policy_document.namespace_service_policy_document.json}"
}
