terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.76"
    }
  }
}

# Create a Warehouse
resource "snowflake_warehouse" "maksims_warehouse" {
  name           = var.warehouse_name
  warehouse_size = var.warehouse_size
  auto_suspend = var.auto_suspend
  initially_suspended = var.initially_suspended
}