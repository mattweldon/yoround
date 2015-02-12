require 'sequel'
require 'sqlite3'
database = Sequel.sqlite('../db/yoround.sqlite3')

database.alter_table :drinkers do
  add_column :skipped_last_nomination, FalseClass, :default=>false
  add_column :skipped_nomination_at, Time, :default=>Time.now
end