terraform {
    required_providers {
        snowflake = {
        source  = "Snowflake-Labs/snowflake"
        }
    }
}
# Create a Database
resource "snowflake_database" "maksims_database" {
  name = var.database_name
}