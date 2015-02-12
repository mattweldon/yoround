module Repositories
  module Sqlite
    class BaseRepository

      def initialize
        puts 'REPO INIT'
        @db = Sequel.sqlite(File.expand_path('../db/yoround.sqlite3', __FILE__))
        puts 'DB CONNECTED'
        @id_counter = 0
        @records = []
      end

      # # Gets all records currently stored in the repo.
      # def all
      #   copy_and_return(@records)
      # end

      # Finds a single record by its id.
      def find(id)
        find_one do |record|
          record.id == id
        end
      end

      # # Finds the first record in the repository for a given query.
      # def find_one(&block)
      #   copy_and_return(@records.find(&block))
      # end

      # # Finds all records in the repository for a given query.
      # def find_all(&block)
      #   copy_and_return(@records.select(&block))
      # end

      # Saves the object to the persistance store.
      # Returns true/falsed depending on the success of the operation,
      def save(obj)
        # if obj.errors.empty?
          set_or_replace_record obj
        #   true
        # else
        #   false
        # end
      end

      # Inserts the record if it doesn't exist in the store and removes/inserts
      # the record if it does.
      def set_or_replace_record(obj)
        @records.delete_if {|record| record.id == obj.id }
        obj.id ||= (@id_counter += 1)

        # Dup to clean up any extra added pieces, like Errors
        @records << obj.dup

        obj
      end

    end
  end
end