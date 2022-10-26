locals {
  account_name    = "product_account"
  # your aws account ID
  aws_account_id  = ""
  # you can leave this as it is. This is the environment name
  iam_name_prefix = "rd"
  # the company name is required, you can use a a abbreviation
  company_name    = ""
  # this profiles can be used as the profile in your aws cli configuration
  aws_profile     = "tf_${local.iam_name_prefix}_${local.company_name}_role"
  # the role arn for the assumed role.
  arn_role        = "arn:aws:iam::${local.aws_account_id}:role/${local.aws_profile}" // "arn:aws:iam::{{aws_account_id}}:role/{{aws_profile}}"
}
