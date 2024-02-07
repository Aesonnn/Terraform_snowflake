terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.76"
    }
  }
}
# Provider Configuration
# Variables are defined in variables.tf and the value is set in terraform.tfvar
provider "snowflake" {
  account  = var.snowflake_account  # The account name.
  user     = var.snowflake_user     # The username to use for authentication.
  password = var.snowflake_password # The password to use for authentication.
  role     = var.snowflake_role     # The role to use for authentication.
}   