module Repositories
  module InMemory
    class RoundRepository < BaseRepository
      
      # Finds the first record in the repository for a given query.
      def find_by_drinker(name)
        find_one do |r|
          r if r.drinkers.include? name
        end
      end

    end
  end
end