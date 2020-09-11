output "role_name" {
  value = "${aws_iam_role.service_role.name}"
}

output "role_arn" {
  value = "${aws_iam_role.service_role.arn}"
}
