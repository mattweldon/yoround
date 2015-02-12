module Repositories
  module Sqlite
    class DrinkerRepository < BaseRepository

      def all
        resultset = []
        drinker = @db[:drinkers]
        drinker.each do |row|
          resultset << map_db_row_to_drinker(row)
        end
        resultset.flatten.compact
      end

      def find_by_name(name)
        resultset = []
        drinker = @db[:drinkers]
        row = drinker.where(:name => name).first

        map_db_row_to_drinker(row) unless row.nil?
      end

      def save(obj)

        @drinker = @db[:drinkers]
        @drinker_yo_history = @db[:drinker_yo_history]
        if @drinker.where(:name => obj.name).count > 0
          # update
          update_row(obj)
        else
          #create
          create_row(obj)
        end
        @drinker.where(:name => obj.name).first
      end

      def cleardown!
        @db[:drinkers].truncate
        @db[:drinker_yo_history].truncate
      end

      private

        def map_db_row_to_drinker(row)
          drinker = Drinker.new(row.fetch(:name) { '' })
          drinker.id = row.fetch(:id) { -1 }
          drinker.num_rounds_made = row.fetch(:num_rounds_made) { 0 }
          drinker.last_round_made = row.fetch(:last_round_made) { 0 }
          drinker.is_nominated = row.fetch(:is_nominated) { false }
          drinker.nominated_at = row.fetch(:nominated_at) { Time.now }

          drinker_yo_history = @db[:drinker_yo_history]

          drinker_yo_history.where(:drinker_id => drinker.id).each do |history|
            drinker.yo_history << history.fetch(:occurred_at) { [] }
          end

          drinker.yo_history = drinker.yo_history.flatten.compact
          drinker
        end

        def update_row(obj)
          @drinker.where(:id => obj.id).update({
            :name => obj.name, 
            :num_rounds_made => obj.num_rounds_made, 
            :last_round_made => obj.last_round_made,
            :is_nominated => obj.is_nominated,
            :nominated_at => obj.nominated_at
          })

          obj.yo_history.each do |h|
            @drinker_yo_history.where(:drinker_id => obj.id, :occurred_at => h).delete
            @drinker_yo_history.insert(:drinker_id => obj.id, :occurred_at => h)
          end
        end

        def create_row(obj)
          @drinker.insert({
            :name => obj.name, 
            :num_rounds_made => obj.num_rounds_made, 
            :last_round_made => obj.last_round_made,
            :is_nominated => obj.is_nominated,
            :nominated_at => obj.nominated_at
          })
        end

    end
  end
end