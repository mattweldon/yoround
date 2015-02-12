module Repositories
  module Sqlite
    class SettingsRepository < BaseRepository

      def all
        resultset = []
        settings = @db[:settings]
        settings.each do |row|
          setting = Settings.new
          setting.high_round_demand = row.fetch(:high_round_demand) { 6 }
          setting.long_round_gap_hours = row.fetch(:long_round_gap_hours) { 1 }
          setting.min_round_gap_hours = row.fetch(:min_round_gap_hours) { 0.25 }
          resultset << setting
        end
        resultset
      end

      def save(obj)
        settings = @db[:settings]

        if settings.count > 0
          settings.update({
            :high_round_demand => obj.high_round_demand,
            :long_round_gap_hours => obj.long_round_gap_hours,
            :min_round_gap_hours => obj.min_round_gap_hours
          })
        else
          settings.insert({
            :high_round_demand => obj.high_round_demand,
            :long_round_gap_hours => obj.long_round_gap_hours,
            :min_round_gap_hours => obj.min_round_gap_hours
          })
        end
      end

    end
  end
end