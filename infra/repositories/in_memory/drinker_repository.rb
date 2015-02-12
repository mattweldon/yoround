module Repositories
  module InMemory
    class DrinkerRepository < BaseRepository

      def find_by_name(name)
        find_one do |drinker|
          drinker.name == name 
        end
      end

    end
  end
end