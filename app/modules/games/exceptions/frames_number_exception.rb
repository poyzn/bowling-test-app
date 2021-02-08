module Games
  module Exceptions
    class FramesNumberException < StandardError
      def message
        'Frame number is invalid'
      end
    end
  end
end