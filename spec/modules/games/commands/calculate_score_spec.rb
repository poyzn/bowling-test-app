require 'rails_helper'

describe Games::Commands::CalculateScore do
  context 'game in progress' do
    let(:bonus) {[]}
    it 'calculates score' do
      frames = [[1,1],[1,1]] + [[]] * 8
      subject = described_class.new frames, bonus
      expect(subject.call).to eq([2,4] + [nil] * 8)
    end
    it 'does not calculate score for an incomplete frame' do
      frames = [[1,1],[1]] + [[]] * 8
      subject = described_class.new frames, bonus
      expect(subject.call).to eq([2] + [nil] * 9)
    end
    it 'doesnt show score for spare frame without next delivery' do
      frames = [[5,5],[5,5]] + [[]] * 8
      subject = described_class.new frames, bonus
      expect(subject.call).to eq([15] + [nil] * 9)
    end
    it 'shows score for spare frame with next delivery' do
      frames = [[5,5],[5,5],[5]] + [[]] * 7
      subject = described_class.new frames, bonus
      expect(subject.call).to eq([15,30] + [nil] * 8)
    end
    it 'calculates score with incomplete frame' do
      frames = [[5,5],[5]] + [[]] * 8
      subject = described_class.new frames, bonus
      expect(subject.call).to eq([15] + [nil] * 9)
    end
  end

  context 'spares' do
    it 'calculates score without bonus' do
      frames = [[0,10]] * 10
      bonus = []
      subject = described_class.new frames, bonus
      expect(subject.call).to eq [10,20,30,40,50,60,70,80,90,nil]
    end
    it 'calculates score with spares' do
      frames = [[0,10]] * 10
      bonus = [5]
      subject = described_class.new frames, bonus
      expect(subject.call).to eq [10,20,30,40,50,60,70,80,90,105]
    end
  end

  context "strikes" do
    it 'calculates score without bones' do
      frames = [[10,0]] * 10
      bonus = []
      subject = described_class.new frames, bonus
      expect(subject.call).to eq [30,60,90,120,150,180,210,240,nil,nil]
    end
    it 'calculates score with partial bones deliveries' do
      frames = [[10,0]] * 10
      bonus = [10]
      subject = described_class.new frames, bonus
      expect(subject.call).to eq [30,60,90,120,150,180,210,240,270,nil]
    end
    it 'calculates score with scores' do
      frames = [[10,0]] * 10
      bonus = [10,10]
      subject = described_class.new frames, bonus
      expect(subject.call).to eq [30,60,90,120,150,180,210,240,270,300]
    end
  end
end