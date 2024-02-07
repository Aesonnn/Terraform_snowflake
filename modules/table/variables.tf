variable "database_name" {
  type = string
}
variable "schema_name" {
  type = string
}
variable "table_name" {
  type = string
}
variable "table_columns" {
  description = "Columns for the table"
  type = list(object({
    name = string
    type = string
  }))

  default = [
    {
      name = "ID"
      type = "INTEGER"
    },
    {
      name = "Make"
      type = "VARCHAR(100)"
    },
    {
      name = "checkedin_at"
      type = "TIMESTAMP_LTZ"
    },
    {
      name = "Status"
      type = "BOOLEAN"
    }
  ]
}