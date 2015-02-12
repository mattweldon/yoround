module Repositories
  module InMemory
    class BaseRepository

      def initialize
        @id_counter = 0
        @records = []
      end

      def unique?(object, attr_name)
        @records.values.none? do |member|
          object.id != member.id && 
            member.public_send(attr_name) == object.public_send(attr_name)
        end
      end

      # Gets all records currently stored in the repo.
      def all
        copy_and_return(@records)
      end

      # Finds a single record by its id.
      def find(id)
        find_one do |record|
          record.id == id
        end
      end

      # Finds the first record in the repository for a given query.
      def find_one(&block)
        copy_and_return(@records.find(&block))
      end

      # Finds all records in the repository for a given query.
      def find_all(&block)
        copy_and_return(@records.select(&block))
      end

      # Clones result or array and returns it ensuring any changes don't
      # alter the values stored in `@records`.
      def copy_and_return(result_or_array)
        if result_or_array.nil?
          nil
        elsif result_or_array.is_a?(Array)
          result_or_array.map {|r| copy_and_return(r) }
        else
          result_or_array.clone
        end
      end

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