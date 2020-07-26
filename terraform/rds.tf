# When an instance is created, the default (readonly) option and parameter groups are created for
# the major version, if they don't exist:
#
# - option g.: `default:mysql-8-0`
# - parameter g.: `default.mysql8.0`
#
# A subnet is group is created as well, and a subnet if requested.

resource "aws_db_instance" "demo" {
  identifier = "database-1"

  engine         = "mysql"
  engine_version = "8.0.20"
  instance_class = "db.t2.micro"

  copy_tags_to_snapshot = true
  skip_final_snapshot   = true

  # The password is not required for an imported resource, however, if it's subsequently specified,
  # it will be marked as changed even if it matches.
  # Note the pwd is stored in the statefile!
  #
  # password = "password"
}

resource "aws_db_subnet_group" "default" {
  name        = "default-vpc-0c9209e70c0813162"
  description = "Created from the RDS Management Console" # Console default

  subnet_ids = [
    aws_subnet.main.id,
    aws_subnet.main2.id
  ]
}

# AWS is inconsistent - the default PG has dots, which are actually disallowed.
# This PG can't be deleted, and can't be kept also if imported (due to naming), so it's left
# commented here only for reference.
#
# resource "aws_db_parameter_group" "default" {
#   name = "default.mysql.80"
#
#   family = "mysql8.0"
#
#   parameter {
#     name  = "character_set_server"
#     value = "utf8"
#   }
# }

# Inconsistency here as well - colon not allowed.
#
# resource "aws_db_option_group" "default" {
#   name                 = "defaultmysql-8-0"
#   engine_name          = "mysql"
#   major_engine_version = "8.0"
#
#   option {
#     option_name = "Timezone"
#
#     option_settings {
#       name  = "TIME_ZONE"
#       value = "UTC"
#     }
#   }
# }
