// Provides information on GCP provider config
data "google_client_config" "default" {}

locals {
  project-id = "${var.project != null ? var.project : data.google_client_config.default.project}"
}

resource "google_sql_database_instance" "default" {
  name                 = "${var.name}"
  project              = "${local.project-id}"
  region               = "${var.region}"

  database_version     = "${var.database_version}"
  master_instance_name = "${var.master_instance_name}"

  settings {
    tier                        = "${var.tier}"
    activation_policy           = "${var.activation_policy}"
    authorized_gae_applications = "${var.authorized_gae_applications}"
    availability_type           = "${var.availability_type}"
    disk_autoresize             = "${var.disk_autoresize}"
    disk_size                   = "${var.disk_size}"
    disk_type                   = "${var.disk_type}"
    replication_type            = "${var.replication_type}"
    user_labels                 = "${var.labels}"

    dynamic "database_flags"{
      for_each = var.database_flags == null ? [] : var.database_flags

      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }

    dynamic "backup_configuration" {
      for_each = var.backup_configuration == null ? [] : list(var.backup_configuration)

      content {
        binary_log_enabled = database_version == "POSTGRES_9_6" ? null : backup_configuration.value.enabled
        enabled = backup_configuration.value.enabled
        start_time = backup_configuration.value.start_time
      }
    }

    dynamic "ip_configuration" {
      for_each = var.ip_configuration == null ? [] : list(var.ip_configuration)

      content {
        ipv4_enabled        = ip_configuration.value.ipv4_enabled
        private_network     = ip_configuration.value.private_network
        require_ssl         = ip_configuration.value.require_ssl
        dynamic "authorized_networks"{
          for_each = var.authorized_networks == null ? [] : var.authorized_networks

          content {
            expiration_time = authorized_networks.value.expiry
            name            = authorized_networks.value.name
            value           = authorized_networks.value.ip
          }
        }
      }
    }

    dynamic "location_preference" {
      for_each = var.location_preference == null ? [] : list(var.location_preference)

      content {
        follow_gae_application = location_preference.value.gae_app
        zone                   = location_preference.value.zone
      }
    }

    dynamic "maintenance_window" {
      for_each = var.maintenance_window == null ? [] : list(var.maintenance_window)

      content {
        day          = maintenance_window.value.day
        hour         = maintenance_window.value.hour
        update_track = maintenance_window.value.update_track
      }
    }
  }

}

resource "google_sql_database" "default" {
  count     = "${var.databases == null ? 0 : length(var.databases)}"
  project   = "${local.project-id}"
  instance  = "${google_sql_database_instance.default.name}"

  name      = "${var.databases[count.index].db_name}"
  charset   = "${var.databases[count.index].charset}"
  collation = "${var.databases[count.index].collation}"
}

resource "random_id" "user-password" {
  byte_length = 8
}

resource "google_sql_user" "default" {
  count    = "${var.users == null ? 0 : length(var.users)}"
  project  = "${local.project-id}"
  instance = "${google_sql_database_instance.default.name}"
  
  name     = "${var.users[count.index].user_name}"
  host     = "${var.users[count.index].user_host}"
  password = "${var.users[count.index].user_password == null ? random_id.user-password.hex : var.users[count.index].user_password}"
}