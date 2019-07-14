# General Variables
variable "project" {
  description = "The project to deploy to, if not set the default provider project is used."
  type        = "string"
  default     = null
}

variable "module_dependency" {
  description = "This is a dummy value to great module dependency. Output from another module can be passed down in order to enforce dependencies"
  type        = string
  default     = null
}

variable "region" {
  description = "Region for cloud resources"
  type        = string
}

variable "name" {
  description = "Name for the database instance. Must be unique and cannot be reused for up to one week."
  type        = string
}

variable "database_version" {
  description = "The MySQL version to use. Can be MYSQL_5_6, MYSQL_5_7 or POSTGRES_9_6 for second-generation instances, or MYSQL_5_5 or MYSQL_5_6 for first-generation instances."
  type        = string
  default     = "MYSQL_5_7"
}

variable "master_instance_name" {
  description = "The name of the master instance to replicate"
  type        = string
  default     = null
}

# Settings config

variable "tier" {
  description = "The machine tier (First Generation) or type (Second Generation) to use. See tiers for more details and supported versions. Postgres supports only shared-core machine types such as db-f1-micro, and custom machine types such as db-custom-2-13312"
  type        = string
  default     = "db-f1-micro"
}

variable "activation_policy" {
  description = "This specifies when the instance should be active. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  type        = string
  default     = "ALWAYS"
}

variable "authorized_gae_applications" {
  description = "A list of Google App Engine (GAE) project names that are allowed to access this instance."
  type        = "list"
  default     = null
}

variable "availability_type" {
  description = "This specifies whether a PostgreSQL instance should be set up for high availability (REGIONAL) or single zone (ZONAL)"
  type = string
  default = null
}

variable "disk_autoresize" {
  description = "Second Generation only. Configuration to increase storage size automatically."
  type        = bool
  default     = true
}

variable "disk_size" {
  description = "Second generation only. The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased."
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "Second generation only. The type of data disk: `PD_SSD` or `PD_HDD`."
  type        = string
  default     = "PD_SSD"
}

variable "replication_type" {
  description = "Replication type for this instance, can be one of `ASYNCHRONOUS` or `SYNCHRONOUS`."
  default     = "SYNCHRONOUS"
}

variable "labels" {
  description = "A set of key/value user label pairs to assign to the instance."
  type        = map(string)
  default     = null
}

# blocks

variable "database_flags" {
  description = "List of Cloud SQL flags that are applied to the database server"
  type        = list(object({
    name  = string
    value = string
  }))
  default = null
}

variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  type        = object({
    enabled    = bool
    start_time = string
  })
  default = null
}

variable "ip_configuration" {
  description = "The ip_configuration settings subblock"
  type        = object({
    ipv4_enabled    = bool
    private_network = string
    require_ssl     = bool
  })
  default     = null
}

variable "authorized_networks" {
  description = "authorized_networks"
  type        = list(object({
    expiry = string
    name   = string
    ip     = string
  }))
  default = null
}

variable "location_preference" {
  description = "The location_preference settings subblock"
  type        = object({
    gae_app = string
    zone    = string
  })
  default = null
}

variable "maintenance_window" {
  description = "The maintenance_window settings subblock"
  type        = object({
    day = number
    hour = number
  })
  default = null
}

# DB User

variable "databases" {
  description = "List of databases to create"
  type        = list(object({
    db_name = string
    charset = string
    collation = string
  }))
  default     = null
}

variable "users" {
  description = "List of databases to create"
  type        = list(object({
    user_name = string
    user_host = string
    user_password = string
  }))
  default     = null
}