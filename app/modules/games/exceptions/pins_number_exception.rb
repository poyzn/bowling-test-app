module Games
  module Exceptions
    class PinsNumberException < StandardError
      def message
        'Pins number is invalid'
      end
    end
  end
end