module Games
  module Repositories
    class GameRepository
      def initialize(storage)
        @storage = storage
      end

      def status
        @storage.read
      end

      def status=(data)
        write data
      end

      def start
        @storage.write Commands::BuildGameSchema.new.call
      end

      def add_delivery(pins)
        self.status = Commands::CreateDelivery.new(status, pins).call
      end

      private

      def write(data)
        @storage.write data
      end
    end
  end
end
