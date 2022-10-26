locals {
  account_name    = "product_account"
  aws_account_id  = ""
  iam_name_prefix = "rd"
  company_name    = ""
  aws_profile     = "tf_${local.iam_name_prefix}_${local.company_name}_role"
  arn_role        = "arn:aws:iam::${local.aws_account_id}:role/${local.aws_profile}" // "arn:aws:iam::{{aws_account_id}}:role/{{aws_profile}}"
}
