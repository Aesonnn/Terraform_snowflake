terraform {
    required_providers {
        snowflake = {
        source  = "Snowflake-Labs/snowflake"
        version = "~> 0.76"
        }
    }
}
# Create a Database
resource "snowflake_database" "maksims_database" {
  name = var.database_name
}