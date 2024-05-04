terraform {
    required_providers {
        snowflake = {
        source  = "Snowflake-Labs/snowflake"
        }
    }
}

# Create a Schema within the Database
resource "snowflake_schema" "maksims_schema" {
  database = var.database_name
  name     = var.schema_name
}
