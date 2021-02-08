module Games
  module Presenters
    class GamePresenter < SimpleDelegator
      def as_json
        {
          frames: status[:frames],
          active: status[:active],
          bonus: status[:bonus],
          score: Commands::CalculateScore.new(status[:frames], status[:bonus]).call
        }
      end
    end
  end
end