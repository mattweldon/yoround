module Repositories
  module Sqlite
    class RoundRepository < BaseRepository

      def all
        resultset = []
        @db[:round].each do |row|
          resultset << map_db_row_to_round(row)
        end
        resultset.flatten.compact
      end

      # def find_by_drinker(name)
      #   round_drinker = @db[:round_drinkers].where(:drinker_name => drinker.name).first
        
      #   @db[:round].where(:id => round_drinker.round_id).first
      # end

      def save(obj)
        @rounds = @db[:round]
        @round_demand = @db[:round_demand]
        @round_drinkers = @db[:round_drinkers]

        if @rounds.count > 0
          # update
          update_row(obj)
        else
          create_row(obj)
        end
      end

      def cleardown!
        @db[:round].truncate
        @db[:round_demand].truncate
        @db[:round_drinkers].truncate
      end

      private

        def map_db_row_to_round(row)
          round = Round.new(row.fetch(:name){''})
          round.id = row.fetch(:id){-1}
          round.time_last_made = row.fetch(:time_last_made){Time.now}
          round.person_last_brewed = row.fetch(:person_last_brewed){''}
          round.nominated_brewer = row.fetch(:nominated_brewer){''}
          round.time_nomination_made = row.fetch(:time_nomination_made){Time.now}

          puts "==> RoundRepo ==> Round Demand #{@db[:round_demand].count}"

          puts row

          @db[:round_demand].each do |r|
            puts r
          end

          round.current_demand = @db[:round_demand].where(:round_id => row.fetch(:id){0}).map { |d| d.fetch(:drinker_name){nil} }
          puts "==> RoundRepo ==> Current Demand #{round.current_demand.count}"
          round.drinkers = @db[:round_drinkers].where(:round_id => row.fetch(:id){0}).map { |d| d.fetch(:drinker_name){nil} }
          puts "==> RoundRepo ==> Drinkers #{round.current_demand.count}"

          round
        end

        def update_row(obj)
          @rounds.where(:id => obj.id).update({
            :time_last_made => obj.time_last_made, 
            :person_last_brewed => obj.person_last_brewed, 
            :nominated_brewer => obj.nominated_brewer, 
            :time_nomination_made => obj.time_nomination_made
          })

          puts '-- update_row'
          puts obj.inspect

          @round_demand.where(:round_id => obj.id).delete
          obj.current_demand.each do |cd|
            @round_demand.insert(:round_id => obj.id, :drinker_name => cd)
          end

          @round_drinkers.where(:round_id => obj.id).delete
          obj.drinkers do |d|
            @round_drinkers.insert(:round_id => obj.id, :drinker_name => d)
          end
        end

        def create_row(obj)
          round_id = @rounds.insert({
            :time_last_made => obj.time_last_made, 
            :person_last_brewed => obj.person_last_brewed, 
            :nominated_brewer => obj.nominated_brewer, 
            :time_nomination_made => obj.time_nomination_made
          })

          obj.current_demand.each do |cd|
            @round_demand.insert(:round_id => round_id, :drinker_name => cd)
          end

          obj.drinkers do |d|
            @round_drinkers.insert(:round_id => round_id, :drinker_name => d)
          end
        end

    end
  end
end