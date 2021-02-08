module Games
  module Exceptions
    class FrameSizeException < StandardError
      def message
        'Frame size is invalid'
      end
    end
  end
end