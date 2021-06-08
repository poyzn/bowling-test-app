require 'rails_helper'

describe Games::Commands::CalculateScore do
  subject(:perform) { described_class.new(frames, bonus).call }

  let(:frames) { [] }
  let(:bonus) { [] }

  context 'when game in progress' do
    context 'with 8 deliveries' do
      let(:frames) { [[1,1],[1,1]] + [[]] * 8 }

      it 'calculates score' do
        expect(perform).to eq([2,4] + [nil] * 8)
      end
    end

    context 'with incomplete frame' do
      let(:frames) { [[1,1],[1]] + [[]] * 8 }

      it 'does not calculate score for the last frame' do
        expect(perform).to eq([2] + [nil] * 9)
      end
    end

    context 'without next delivery' do
      let(:frames) { [[5,5],[5,5]] + [[]] * 8 }

      it 'doesnt show score for spare frame' do
        expect(perform).to eq([15] + [nil] * 9)
      end
    end

    context 'with next delivery' do
      let(:frames) { [[5,5],[5,5],[5]] + [[]] * 7 }

      it 'shows score for spare frame' do
        expect(perform).to eq([15,30] + [nil] * 8)
      end
    end

    context 'with incomplete frame' do
      let(:frames) { [[5,5],[5]] + [[]] * 8 }

      it 'calculates score' do
        expect(perform).to eq([15] + [nil] * 9)
      end
    end
  end

  context 'with spares' do
    let(:frames) { [[0,10]] * 10 }

    context 'without bonus' do
      it 'calculates score' do
        expect(perform).to eq [10,20,30,40,50,60,70,80,90,nil]
      end
    end

    context 'with spares' do
      let(:bonus) { [5] }

      it 'calculates score' do
        expect(perform).to eq [10,20,30,40,50,60,70,80,90,105]
      end
    end
  end

  context "with strikes" do
    let(:frames) { [[10,0]] * 10 }

    context 'without bonus' do
      it 'calculates score without bones' do
        expect(perform).to eq [30,60,90,120,150,180,210,240,nil,nil]
      end
    end

    context 'with partial bonus deliveries' do
      let(:bonus) { [10] }

      it 'calculates score with partial bones deliveries' do
        expect(perform).to eq [30,60,90,120,150,180,210,240,270,nil]
      end
    end

    context 'with score' do
      let(:bonus) { [10,10] }

      it 'calculates score with scores' do
        expect(perform).to eq [30,60,90,120,150,180,210,240,270,300]
      end
    end
  end
end