terraform {
    required_providers {
        snowflake = {
          source  = "Snowflake-Labs/snowflake"
        }
    }
}

# Create a Role
# This role can be given to any user to check SELECT from car_table
resource "snowflake_role" "car_maintenance_role" {
  name    = var.role_name
  comment = "This is a new role"
}

# Grant usage on the warehouse to the role - car_maintenance_role
resource "snowflake_grant_privileges_to_account_role" "car_maintenance_role_g1" {
  account_role_name  = snowflake_role.car_maintenance_role.name
  privileges = ["USAGE"]
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = var.warehouse_name
  }
}

# Grant usage on the database to the role - car_maintenance_role
resource "snowflake_grant_privileges_to_account_role" "car_maintenance_role_g2" {
  privileges = ["USAGE"]
  account_role_name  = snowflake_role.car_maintenance_role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = var.database_name
  }
}

# Grant usage on the schema to the role - car_maintenance_role
resource "snowflake_grant_privileges_to_account_role" "car_maintenance_role_g3" {
  privileges = ["USAGE"]
  account_role_name  = snowflake_role.car_maintenance_role.name
  on_schema {
    schema_name = "\"${var.database_name}\".\"${var.schema_name}\""
  }
  # Nedeed to ensure the correct order of execution and creation
  depends_on = [snowflake_role.car_maintenance_role]
}

# Grant select on the table to the role - car_maintenance_role
resource "snowflake_grant_privileges_to_account_role" "select_grant" {
  privileges     = ["SELECT"]
  account_role_name  = snowflake_role.car_maintenance_role.name
    on_schema_object {
      object_type = "TABLE"
      object_name = "\"${var.database_name}\".\"${var.schema_name}\".\"${var.table_name}\""
  }
  # Nedeed to ensure the correct order of execution and creation
  depends_on = [snowflake_role.car_maintenance_role]
}