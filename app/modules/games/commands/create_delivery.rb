module Games
  module Commands
    class CreateDelivery
      include Exceptions

      attr_reader :status, :pins, :frame

      def initialize(status, pins)
        @status = status
        @pins = pins.to_i
        @frame = frames[current_frame]
      end

      def call
        raise GameInactiveException unless game_active?
        raise FramesNumberException if frames_number_invalid?
        raise PinsNumberException if invalid_pins_number?
        raise FrameScoreException if frame_score_invalid?
        raise FrameSizeException if frame_size_invalid?

        pins_to_bonus? ? add_pins_to_bonus : add_pins_to_frame
        status[:frames] = frames
        status
      end

      private

      def frames
        status[:frames]
      end

      def current_frame
        status[:current_frame] - 1
      end

      def next_frame!
        status[:current_frame] += 1
      end

      def bonus
        status[:bonus]
      end

      def finish_game!
        status[:active] = false
      end

      def frame_finished?
        frame.size == 2
      end

      def frame_empty?
        frame.none?
      end

      def strike?
        frame == [10,0]
      end

      def spare?
        !strike? && frame.sum == 10
      end

      def last_frame?
        current_frame == 9
      end

      def game_active?
        status[:active] == true
      end

      def frames_number_invalid?
        current_frame > 9
      end

      def frame_size_invalid?
        return true if !last_frame? && frame.size >= 2
        return true if last_frame? && spare? && bonus.size >= 1
        return true if last_frame? && strike? && bonus.size >= 2

        false
      end

      def invalid_pins_number?
        pins < 0 || pins > 10
      end

      def frame_score_invalid?
        if last_frame?
          return true if frame_finished? && !strike? && !spare?
        else
          return true if frame.any? && frame.first + pins > 10
          return true if frame.any? && frame.first == 10
        end

        false
      end

      def add_pins_to_frame
        if frame_empty? && pins == 10
          frames[current_frame] = [10, 0]
        else
          frames[current_frame] << pins
        end
        finish_game! if last_frame? && frame_finished? && !strike? && !spare?
        next_frame! if frame_finished? && !last_frame?
      end

      def add_pins_to_bonus
        status[:bonus] << pins
        finish_game! if spare? && bonus.size == 1
        finish_game! if strike? && bonus.size == 2
      end

      def pins_to_bonus?
        last_frame? && frame_finished? && (strike? || spare?)
      end
    end
  end
end