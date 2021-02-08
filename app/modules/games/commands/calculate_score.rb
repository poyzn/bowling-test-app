module Games
  module Commands
    class CalculateScore

      def initialize(frames, bonus)
        @frames = frames
        @bonus = bonus
      end

      def call
        score = []
        @frames.each_with_index do |frame, frame_index|
          return score if frame_index > 9

          sum = frame.sum
          sum += add_strike_bonus(frame_index) if strike?(frame)
          sum += add_spare_bonus(frame_index) if spare?(frame)
          score << (final_score?(frame_index) ? sum + score&.last.to_i : nil)
        end
        score
      end

      def strike?(frame)
        frame == [10,0]
      end

      def spare?(frame)
        !strike?(frame) && frame.sum == 10
      end

      def final_score?(frame_index)
        frame = @frames[frame_index]
        return final_score_for_strike_frame?(frame_index) if strike?(frame)
        return final_score_for_spare_frame?(frame_index) if spare?(frame)

        frame_finished?(frame)
      end

      def final_score_for_strike_frame?(frame_index)
        next_frame = @frames[frame_index + 1]
        after_next_frame = @frames[frame_index + 2]

        if frame_index == 8
          next_frame.present? && @bonus&.first.present?
        elsif frame_index == 9
          @bonus.size == 2
        else
          next_frame.present? && after_next_frame.present?
        end
      end

      def final_score_for_spare_frame?(frame_index)
        next_frame = @frames[frame_index + 1]
        if frame_index == 9
          @bonus&.first.present?
        else
          next_frame.present?
        end
      end

      def frame_finished?(frame)
        frame.size == 2
      end

      def add_strike_bonus(frame_index)
        sum = 0
        next_frame = @frames[frame_index + 1]
        after_next_frame = @frames[frame_index + 2]

        if frame_index < 8 && strike?(next_frame)
          sum += 10 + after_next_frame.first if after_next_frame.first
        elsif frame_index == 8 && strike?(next_frame)
          sum += 10 + @bonus.first if @bonus.first
        elsif frame_index == 9
          sum += @bonus.sum if @bonus.size == 2
        else
          sum += next_frame.sum if next_frame.size == 2
        end

        sum
      end

      def add_spare_bonus(frame_index)
        sum = 0
        next_frame = @frames[frame_index + 1]

        if frame_index == 9
          sum += @bonus.first if @bonus.first
        else
          sum += next_frame.first if next_frame.first
        end

        sum
      end
    end
  end
end