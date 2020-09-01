data "aws_iam_policy_document" "service_role_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = [
        "ssm.amazonaws.com",
        "ec2.amazonaws.com",
        "events.amazonaws.com",
        "lambda.amazonaws.com",
      ]

      type = "Service"
    }
  }
}

resource "aws_iam_role" "service_role" {
  name               = "${local.prefix}-${var.namespace}-service-role"
  assume_role_policy = "${data.aws_iam_policy_document.service_role_document.json}"
  tags               = "${local.tags}"
}

resource "aws_iam_role_policy_attachment" "attach_ssm_core" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = "${aws_iam_role.service_role.name}"
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_agent_server" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = "${aws_iam_role.service_role.name}"
}

resource "aws_iam_role_policy_attachment" "attach_ec2_readonly_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  role       = "${aws_iam_role.service_role.name}"
}

resource "aws_iam_role_policy_attachment" "attach_service_policy" {
  policy_arn = "${aws_iam_policy.namespace_service_policy.arn}"
  role       = "${aws_iam_role.service_role.name}"
}
