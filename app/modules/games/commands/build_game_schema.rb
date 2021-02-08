module Games
  module Commands
    class BuildGameSchema
      FRAMES_NUM = 10

      def call
        {
          frames: [[]] * FRAMES_NUM,
          current_frame: 1,
          active: true,
          bonus: []
        }
      end
    end
  end
end
