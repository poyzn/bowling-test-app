module Games
  module Exceptions
    class GameInactiveException < StandardError
      def message
        'Game is not active. Start a new game!'
      end
    end
  end
end