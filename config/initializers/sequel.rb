require 'sequel'

Sequel.application_timezone = :local
Sequel.database_timezone = :utc
Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :validation_helpers
