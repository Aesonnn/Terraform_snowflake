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
    account = var.snowflake_account # The account name.
    user = var.snowflake_user
    password = var.snowflake_password
    role = var.snowflake_role
}

# Create a Snowflake Warehouse
resource "snowflake_warehouse" "maksims_warehouse" {
  name           = var.warehouse_name
  warehouse_size = var.warehouse_size
}

# Create a Snowflake Database
resource "snowflake_database" "maksims_database" {
  name = var.database_name
}

# Create a Schema within the Database
resource "snowflake_schema" "maksims_schema" {
  database = snowflake_database.maksims_database.name
  name     = var.schema_name
}

# Create a Table within the schema and database
resource "snowflake_table" "car_table" {
  database = snowflake_database.maksims_database.name
  schema   = snowflake_schema.maksims_schema.name
  name     = var.table_name
  column {
    name = "ID"
    type = "INTEGER"
  }
  column {
    name = "Make"
    type = "VARCHAR(100)"
  }
  column {
    name = "checkedin_at"
    type = "TIMESTAMP_LTZ"
  }
  column {
    name = "Status"
    type = "BOOLEAN"
  }
}

# Create a Role
# This role can be given to any user to check SELECT from car_table
resource "snowflake_role" "car_maintenance_role" {
  name = var.role_name
  comment = "This is a new role"
}

# Grant usage on the warehouse to the role - car_maintenance_role
resource "snowflake_grant_privileges_to_role" "car_maintenance_role_g1" {
  role_name  = snowflake_role.car_maintenance_role.name
  privileges  = ["USAGE"]
      on_account_object {
      object_type = "WAREHOUSE"
      object_name = snowflake_warehouse.maksims_warehouse.name
    }
}

# Grant usage on the database to the role - car_maintenance_role
resource "snowflake_grant_privileges_to_role" "car_maintenance_role_g2" {
  privileges = [ "USAGE" ]
  role_name  = snowflake_role.car_maintenance_role.name
    on_account_object {
      object_type = "DATABASE"
      object_name = snowflake_database.maksims_database.name
    }
}

# Grant usage on the schema to the role - car_maintenance_role
resource "snowflake_grant_privileges_to_role" "car_maintenance_role_g3" {
  privileges = ["USAGE"]
  role_name = snowflake_role.car_maintenance_role.name
  on_schema {
    schema_name = "\"maksims_database\".\"maksims_schema\""
  }
}

# Grant select on the table to the role - car_maintenance_role
resource "snowflake_table_grant" "select_grant" {
  database_name = snowflake_database.maksims_database.name
  schema_name   = snowflake_schema.maksims_schema.name
  table_name    = snowflake_table.car_table.name
  privilege     = "SELECT"
  roles         = [snowflake_role.car_maintenance_role.name]
}
