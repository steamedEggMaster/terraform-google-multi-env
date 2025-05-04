variable "project_id" {
  type        = string
  description = "The project ID to manage the Cloud SQL resources"
}

variable "region" {
  type        = string
  description = "The region of the Cloud SQL resources"
  default     = "us-central1"
}

variable "database_engine" {
  description = <<EOT
The database engine used in the Cloud SQL instance.

Allowed values:
- "POSTGRESQL"
- "MYSQL"

Used for conditional logic when certain features differ by engine, such as `host` in users or `deletion_policy`.

Examples:
- If you're using PostgreSQL, set: "POSTGRESQL"
- If you're using MySQL, set: "MYSQL"
EOT

  type = string

  validation {
    condition     = contains(["POSTGRESQL", "MYSQL"], upper(var.database_engine))
    error_message = "database_engine must be one of: POSTGRESQL, MYSQL (case-insensitive)."
  }
}

variable "name" {
  type        = string
  description = "The name of the Cloud SQL instance"
}

variable "edition" {
  description = "The edition of the Cloud SQL instance, can be ENTERPRISE or ENTERPRISE_PLUS."
  type        = string
  default     = "ENTERPRISE"
}

// required
variable "database_version" {
  description = <<EOT
The database version to use for the Cloud SQL instance.

You can specify versions in either short form (e.g. "14", "8_0") or with explicit engine prefix (e.g. "POSTGRES_14", "MYSQL_8_0").

🟦 PostgreSQL (Cloud SQL supported):
- "POSTGRES_9_6" or "9_6"
- "POSTGRES_10" or "10"
- "POSTGRES_11" or "11"
- "POSTGRES_12" or "12"
- "POSTGRES_13" or "13"
- "POSTGRES_14" or "14"
- "POSTGRES_15" or "15"
- "POSTGRES_16" or "16"

🟥 MySQL (Cloud SQL supported):
- "MYSQL_5_6" or "5_6"
- "MYSQL_5_7" or "5_7"
- "MYSQL_8_0" or "8_0"

All values are case-insensitive.
EOT

  type = string

  validation {
    condition = (
      can(regex("^(POSTGRES_|MYSQL_)?(9_6|10|11|12|13|14|15|16|5_6|5_7|8_0)$", upper(var.database_version)))
    )
    error_message = <<EOT
Invalid database version.
Allowed values are:
- PostgreSQL: "POSTGRES_9_6", "POSTGRES_10", ..., "POSTGRES_16" or "9_6", "10", ..., "16"
- MySQL: "MYSQL_5_6", "MYSQL_5_7", "MYSQL_8_0" or "5_6", "5_7", "8_0"
EOT
  }
}

variable "maintenance_version" {
  description = "The current software version on the instance. This attribute can not be set during creation. Refer to available_maintenance_versions attribute to see what maintenance_version are available for upgrade. When this attribute gets updated, it will cause an instance restart. Setting a maintenance_version value that is older than the current one on the instance will be ignored"
  type        = string
  default     = null
}

variable "availability_type" {
  description = <<EOT
The availability type for the Cloud SQL instance.

- ZONAL: Default. The instance is located in a single zone.
- REGIONAL: High Availability. The instance is located across multiple zones (HA configuration).

Applicable for both PostgreSQL and MySQL.

Allowed values: "ZONAL", "REGIONAL"
EOT

  type    = string
  default = "ZONAL"

  validation {
    condition     = contains(["ZONAL", "REGIONAL"], upper(var.availability_type))
    error_message = "Invalid availability_type. Must be either 'ZONAL' or 'REGIONAL' (case-insensitive)."
  }
}

variable "enable_default_db" {
  description = "Enable or disable the creation of the default database"
  type        = bool
  default     = true
}

variable "db_name" {
  description = "The name of the default database to create. This should be unique per Cloud SQL instance."
  type        = string
  default     = "default"
}

variable "enable_default_user" {
  description = "Enable or disable the creation of the default user"
  type        = bool
  default     = true
}

variable "user_name" {
  description = "The name of the default user"
  type        = string
  default     = "default"
}

variable "user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  type        = string
  default     = ""
}

variable "user_host" {
  description = "The host for the default user"
  type        = string
  default     = "%"
}

variable "root_password" {
  description = "Initial root password during creation"
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = true
}

variable "database_flags" {
  description = <<EOT
A list of database flags to set for the Cloud SQL instance.

Each flag consists of:
- name  = (string) The name of the flag.
- value = (string) The value of the flag.

📌 This supports both PostgreSQL and MySQL, but available flags differ by database type.

🔗 PostgreSQL supported flags: https://cloud.google.com/sql/docs/postgres/flags
🔗 MySQL supported flags: https://cloud.google.com/sql/docs/mysql/flags
✅ Examples:
- PostgreSQL: name = "max_connections", value = "200"
- MySQL:      name = "slow_query_log", value = "on"
EOT

  type = list(object({
    name  = string
    value = string
  }))

  default = []
}


variable "database_deletion_policy" {
  description = <<EOT
The deletion policy for the Cloud SQL *database* resource.

- "DELETE": Default behavior. Deletes the database when the resource is destroyed.
- "ABANDON": Leaves the database intact but removes it from Terraform state.
             ⚠️ Useful for PostgreSQL, where databases can't be deleted if non-cloudsqlsuperuser users still exist.

Allowed values: "DELETE", "ABANDON"
EOT

  type    = string
  default = "DELETE"

  validation {
    condition     = var.database_deletion_policy == null || contains(["DELETE", "ABANDON"], upper(var.database_deletion_policy))
    error_message = "database_deletion_policy must be one of: DELETE, ABANDON (case-insensitive)."
  }
}

variable "user_deletion_policy" {
  description = <<EOT
The deletion policy for the Cloud SQL *user* resource.

- "DELETE": Default behavior. Deletes the user when the resource is destroyed.
- "ABANDON": Leaves the user intact but removes it from Terraform state.
             ⚠️ Useful for PostgreSQL, where users granted SQL roles can't be deleted via the API.

Allowed values: "ABANDON"
EOT

  type    = string
  default = ""

  validation {
    condition     = var.user_deletion_policy == null || contains(["", "ABANDON"], upper(var.user_deletion_policy))
    error_message = "user_deletion_policy must be one of: ABANDON (case-insensitive)."
  }
}

variable "data_cache_enabled" {
  description = "Whether data cache is enabled for the instance. Defaults to false. Feature is only available for ENTERPRISE_PLUS tier and supported database_versions"
  type        = bool
  default     = false
}

variable "additional_users" {
  description = "A list of users to be created in your cluster. A random password would be set for the user if the `random_password` variable is set."
  type = list(object({
    name            = string
    password        = string
    random_password = bool
  }))
  default = []
  validation {
    condition     = length([for user in var.additional_users : false if(user.random_password == false && (user.password == null || user.password == "")) || (user.random_password == true && (user.password != null && user.password != ""))]) == 0
    error_message = "Password is a requird field for built_in Postgres users and you cannot set both password and random_password, choose one of them."
  }
}

variable "additional_databases" {
  description = "A list of databases to be created in your cluster"
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
  default = []
}

variable "master_instance_name" {
  type        = string
  description = "Name of the master instance if this is a failover replica. Required for creating failover replica instance. Not needed for master instance. When removed, next terraform apply will promote this failover failover replica instance as master instance"
  default     = null
}

variable "instance_type" {
  type        = string
  description = "The type of the instance. The supported values are SQL_INSTANCE_TYPE_UNSPECIFIED, CLOUD_SQL_INSTANCE, ON_PREMISES_INSTANCE and READ_REPLICA_INSTANCE. Set to READ_REPLICA_INSTANCE if master_instance_name value is provided"
  default     = "CLOUD_SQL_INSTANCE"
}

variable "random_instance_name" {
  type        = bool
  description = "Sets random suffix at the end of the Cloud SQL resource name"
  default     = false
}

variable "tier" {
  description = "The tier for the Cloud SQL instance."
  type        = string
  default     = "db-f1-micro"
}

variable "zone" {
  type        = string
  description = "The zone for the Cloud SQL instance, it should be something like: `us-central1-a`, `us-east1-c`."
  default     = null
}

variable "secondary_zone" {
  type        = string
  description = "The preferred zone for the replica instance, it should be something like: `us-central1-a`, `us-east1-c`."
  default     = null
}

variable "follow_gae_application" {
  type        = string
  description = "A Google App Engine application whose zone to remain in. Must be in the same region as this instance."
  default     = null
}

variable "activation_policy" {
  description = "The activation policy for the Cloud SQL instance.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`."
  type        = string
  default     = "ALWAYS"
}

variable "deletion_protection_enabled" {
  description = "Enables protection of an Cloud SQL instance from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform)."
  type        = bool
  default     = false
}

variable "read_replica_deletion_protection_enabled" {
  description = "Enables protection of replica instance from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform)."
  type        = bool
  default     = false
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size."
  type        = bool
  default     = true
}

variable "disk_autoresize_limit" {
  description = "The maximum size to which storage can be auto increased."
  type        = number
  default     = 0
}

variable "disk_size" {
  description = "The disk size (in GB) for the Cloud SQL instance."
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "The disk type for the Cloud SQL instance."
  type        = string
  default     = "PD_SSD"
}

variable "pricing_plan" {
  description = "The pricing plan for the Cloud SQL instance."
  type        = string
  default     = "PER_USE"
}

variable "maintenance_window_day" {
  description = "The day of week (1-7) for the Cloud SQL instance maintenance."
  type        = number
  default     = 1
}

variable "maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the Cloud SQL instance maintenance."
  type        = number
  default     = 23
}

variable "maintenance_window_update_track" {
  description = "The update track of maintenance window for the Cloud SQL instance maintenance.Can be either `canary` or `stable`."
  type        = string
  default     = "canary"
}

variable "user_labels" {
  description = "The key/value labels for the Cloud SQL instances."
  type        = map(string)
  default     = {}
}

variable "deny_maintenance_period" {
  description = <<EOT
The Deny Maintenance Period fields to prevent automatic maintenance from occurring during a 90-day time period.

✅ Supported for both **PostgreSQL** and **MySQL** Cloud SQL instances.

Each entry defines:
- `start_date`: The start date in MM-DD format (e.g., "12-23")
- `end_date`:   The end date in MM-DD format (e.g., "01-07")
- `time`:       The time in UTC (e.g., "22:00:00")

⚠️ Only one entry is allowed per instance.

See more details:
- PostgreSQL: https://cloud.google.com/sql/docs/postgres/maintenance
- MySQL:      https://cloud.google.com/sql/docs/mysql/maintenance#deny-maintenance
EOT

  type = list(object({
    end_date   = string
    start_date = string
    time       = string
  }))
  default = []
}

variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  type = object({
    enabled                        = optional(bool, false)
    start_time                     = optional(string)
    location                       = optional(string)
    point_in_time_recovery_enabled = optional(bool, false)
    transaction_log_retention_days = optional(string)
    retained_backups               = optional(number)
    retention_unit                 = optional(string)
  })
  default = {}
}

variable "insights_config" {
  description = "The insights_config settings for the database."
  type = object({
    query_plans_per_minute  = optional(number, 5)
    query_string_length     = optional(number, 1024)
    record_application_tags = optional(bool, false)
    record_client_address   = optional(bool, false)
  })
  default = null
}

variable "password_validation_policy_config" {
  description = "The password validation policy settings for the database instance."
  type = object({
    min_length                  = optional(number)
    complexity                  = optional(string)
    reuse_interval              = optional(number)
    disallow_username_substring = optional(bool)
    password_change_interval    = optional(string)
  })
  default = null
}

variable "ip_configuration" {
  description = "The ip configuration for the Cloud SQL instances."
  type = object({
    authorized_networks                           = optional(list(map(string)), [])
    ipv4_enabled                                  = optional(bool, true)
    private_network                               = optional(string)
    ssl_mode                                      = optional(string)
    allocated_ip_range                            = optional(string)
    enable_private_path_for_google_cloud_services = optional(bool, false)
    psc_enabled                                   = optional(bool, false)
    psc_allowed_consumer_projects                 = optional(list(string), [])
  })
  default = {}
}

// Read Replicas
variable "read_replicas" {
  description = "List of read replicas to create. Encryption key is required for replica in different region. For replica in same region as master set encryption_key_name = null"
  type = list(object({
    name                  = string
    name_override         = optional(string)
    tier                  = optional(string)
    edition               = optional(string)
    availability_type     = optional(string)
    zone                  = optional(string)
    disk_type             = optional(string)
    disk_autoresize       = optional(bool)
    disk_autoresize_limit = optional(number)
    disk_size             = optional(string)
    user_labels           = map(string)
    database_flags = optional(list(object({
      name  = string
      value = string
    })), [])
    insights_config = optional(object({
      query_plans_per_minute  = optional(number, 5)
      query_string_length     = optional(number, 1024)
      record_application_tags = optional(bool, false)
      record_client_address   = optional(bool, false)
    }), null)
    ip_configuration = object({
      authorized_networks                           = optional(list(map(string)), [])
      ipv4_enabled                                  = optional(bool)
      private_network                               = optional(string, )
      ssl_mode                                      = optional(string)
      allocated_ip_range                            = optional(string)
      enable_private_path_for_google_cloud_services = optional(bool, false)
      psc_enabled                                   = optional(bool, false)
      psc_allowed_consumer_projects                 = optional(list(string), [])
    })
    encryption_key_name = optional(string)
    data_cache_enabled  = optional(bool)
  }))
  default = []
}

variable "read_replica_name_suffix" {
  description = "The optional suffix to add to the read instance name"
  type        = string
  default     = ""
}

variable "db_charset" {
  description = "The charset for the default database"
  type        = string
  default     = ""
}

variable "db_collation" {
  description = "The collation for the default database. Example: 'en_US.UTF8'"
  type        = string
  default     = ""
}

variable "iam_users" {
  description = "A list of IAM users to be created in your CloudSQL instance. iam.users.type can be CLOUD_IAM_USER, CLOUD_IAM_SERVICE_ACCOUNT, CLOUD_IAM_GROUP and is required for type CLOUD_IAM_GROUP (IAM groups)"
  type = list(object({
    id    = string,
    email = string,
    type  = optional(string)
  }))
  default = []
}

variable "create_timeout" {
  description = "The optional timout that is applied to limit long database creates."
  type        = string
  default     = "30m"
}

variable "update_timeout" {
  description = "The optional timout that is applied to limit long database updates."
  type        = string
  default     = "30m"
}

variable "delete_timeout" {
  description = "The optional timout that is applied to limit long database deletes."
  type        = string
  default     = "30m"
}

variable "encryption_key_name" {
  description = "The full path to the encryption key used for the CMEK disk encryption"
  type        = string
  default     = null
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}

variable "read_replica_deletion_protection" {
  description = "Used to block Terraform from deleting replica SQL Instances."
  type        = bool
  default     = false
}

variable "enable_random_password_special" {
  description = "Enable special characters in generated random passwords."
  type        = bool
  default     = false
}

variable "connector_enforcement" {
  description = "Enforce that clients use the connector library"
  type        = bool
  default     = false
}

variable "enable_google_ml_integration" {
  description = "Enable database ML integration"
  type        = bool
  default     = false
}

variable "database_integration_roles" {
  description = "The roles required by default database instance service account for integration with GCP services"
  type        = list(string)
  default     = []
}