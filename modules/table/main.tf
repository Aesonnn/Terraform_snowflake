terraform {
    required_providers {
        snowflake = {
        source  = "Snowflake-Labs/snowflake"
        }
    }
}

# Create a Table within the schema and database
resource "snowflake_table" "car_table" {
  database = var.database_name
  schema   = var.schema_name
  name     = var.table_name
  # Columns for the table
  dynamic "column" {
    for_each = var.table_columns
    content {
      name = column.value.name
      type = column.value.type
    }
    
  }

}