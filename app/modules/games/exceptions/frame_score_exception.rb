module Games
  module Exceptions
    class FrameScoreException < StandardError
      def message
        'Frame score is invalid'
      end
    end
  end
end