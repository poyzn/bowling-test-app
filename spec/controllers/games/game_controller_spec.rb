require 'rails_helper'

describe Games::GameController do
  before(:each) do
    post :start
  end

  describe 'POST #start' do
    it 'starts game if a game not started' do
      expect(json[:status]).to eq('success')
      expect(response_data).to eq(message: 'Game is started!')
    end
  end

  describe 'GET #show' do
    it 'returns default game schema when game is started' do
      get :show
      expect(json[:status]).to eq('success')
      expect(response_data[:frames]).to eq([[]] * 10)
      expect(response_data[:active]).to eq(true)
      expect(response_data[:bonus]).to eq([])
      expect(response_data[:score]).to eq([nil] * 10)
    end
  end

  describe 'POST #deliveries' do
    context 'games without bonus deliveries' do
      it 'creates deliveries for first frame' do
        post :deliveries, params: { pins: 4 }
        post :deliveries, params: { pins: 5 }
        expect(json[:status]).to eq('success')
        expect(response_data[:frames]).to eq([[4,5]] + [[]] * 9)
        expect(response_data[:active]).to eq(true)
        expect(response_data[:bonus]).to eq([])
        expect(response_data[:score]).to eq([9] + [nil] * 9)
      end

      it 'creates deliveries for all frames' do
        10.times do
          post :deliveries, params: { pins: 2 }
          post :deliveries, params: { pins: 3 }
        end
        expect(json[:status]).to eq('success')
        expect(response_data[:frames]).to eq([[2,3]] * 10)
        expect(response_data[:active]).to eq(false)
        expect(response_data[:bonus]).to eq([])
        expect(response_data[:score]).to eq([5,10,15,20,25,30,35,40,45,50])
      end

      it 'creates deliveries with spare frames' do
        10.times do
          post :deliveries, params: { pins: 0 }
          post :deliveries, params: { pins: 10 }
        end
        expect(json[:status]).to eq('success')
        expect(response_data[:frames]).to eq([[0,10]] * 10)
        expect(response_data[:active]).to eq(true)
        expect(response_data[:bonus]).to eq([])
        expect(response_data[:score]).to eq([10,20,30,40,50,60,70,80,90,nil])
      end

      it 'does not accept pins number less than 0' do
        post :deliveries, params: { pins: -1 }
        expect(json[:status]).to eq('error')
        expect(response_data[:message]).to eq Games::Exceptions::PinsNumberException.new.message
      end

      it 'does not accept pins number bigger than 10' do
        post :deliveries, params: { pins: 11 }
        expect(json[:status]).to eq('error')
        expect(response_data[:message]).to eq Games::Exceptions::PinsNumberException.new.message
      end

      it 'does not accept pins if sum of the frame is bigger than 10' do
        post :deliveries, params: { pins: 5 }
        post :deliveries, params: { pins: 6 }
        expect(json[:status]).to eq('error')
        expect(response_data[:message]).to eq Games::Exceptions::FrameScoreException.new.message
      end
    end

    context 'with bonus frames' do
      it 'adds bonus delivery if last frame is spare' do
        10.times do
          post :deliveries, params: { pins: 0 }
          post :deliveries, params: { pins: 10 }
        end
        post :deliveries, params: { pins: 10 }
        expect(json[:status]).to eq('success')
        expect(response_data[:frames]).to eq([[0,10]] * 10)
        expect(response_data[:active]).to eq(false)
        expect(response_data[:bonus]).to eq([10])
        expect(response_data[:score]).to eq([10,20,30,40,50,60,70,80,90,110])
      end

      it 'returns an error on delivery if the game is finished' do
        10.times do
          post :deliveries, params: { pins: 0 }
          post :deliveries, params: { pins: 10 }
        end
        post :deliveries, params: { pins: 10 }
        post :deliveries, params: { pins: 10 }
        expect(json[:status]).to eq('error')
        expect(response_data[:message]).to eq Games::Exceptions::GameInactiveException.new.message
      end

      it 'adds 1 bonus delivery if last frame is strike' do
        11.times do
          post :deliveries, params: { pins: 10 }
        end
        expect(json[:status]).to eq('success')
        expect(response_data[:frames]).to eq([[10,0]] * 10)
        expect(response_data[:active]).to eq(true)
        expect(response_data[:bonus]).to eq([10])
        expect(response_data[:score]).to eq([30,60,90,120,150,180,210,240,270,nil])
      end

      it 'adds 2 bonus deliveries if last frame is strike' do
        12.times do
          post :deliveries, params: { pins: 10 }
        end
        expect(json[:status]).to eq('success')
        expect(response_data[:frames]).to eq([[10,0]] * 10)
        expect(response_data[:active]).to eq(false)
        expect(response_data[:bonus]).to eq([10,10])
        expect(response_data[:score]).to eq([30,60,90,120,150,180,210,240,270,300])
      end
    end
  end
end