module "warehouse" {
    source = "./modules/warehouse"
    warehouse_name = var.warehouse_name
    warehouse_size   = var.warehouse_size
    auto_suspend = 60
    initially_suspended = true
}

module "database" {
    source = "./modules/database"
    database_name = var.database_name
    depends_on = [ module.warehouse ]
}

module "schema" {
    source = "./modules/schema"
    database_name = var.database_name
    schema_name = var.schema_name
    depends_on = [ module.database ]
}

module "table" {
    source = "./modules/table"
    database_name = var.database_name
    schema_name = var.schema_name
    table_name = var.table_name
    depends_on = [ module.schema ]
}

module "role" {
    source = "./modules/role"
    warehouse_name = var.warehouse_name
    database_name = var.database_name
    schema_name = var.schema_name
    table_name = var.table_name
    role_name = var.role_name
    depends_on = [ module.table ]
}
