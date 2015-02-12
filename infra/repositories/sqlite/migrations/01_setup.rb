require 'sequel'
require 'sqlite3'
database = Sequel.sqlite('../db/yoround.sqlite3')

database.create_table :drinkers do
  primary_key :id
  String :name
  Integer :num_rounds_made
  Time :last_round_made
  FalseClass :is_nominated
  Time :nominated_at  
end


database.create_table :drinker_yo_history do
  Integer :drinker_id
  Time :occurred_at
end


database.create_table :round do
  primary_key :id
  Time :time_last_made
  String :person_last_brewed
  String :nominated_brewer
  Time :time_nomination_made
end


database.create_table :round_demand do
  Integer :round_id
  String :drinker_name
end


database.create_table :round_drinkers do
  Integer :round_id
  Integer :drinker_name
end


database.create_table :settings do
  Integer :high_round_demand
  Integer :long_round_gap_hours
  Integer :min_round_gap_hours
end

