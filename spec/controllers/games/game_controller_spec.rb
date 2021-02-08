require 'rails_helper'

describe Games::GameController do
  describe 'POST #start' do
    it 'starts game if a game not started' do
      post :start
      expect(json[:status]).to eq('success')
      expect(response_data).to eq(message: 'Game is started!')
    end
  end

  describe 'GET #show' do
    it 'returns status when game is started' do
      post :start
      get :show
      expect(json[:status]).to eq('success')
      expect(response_data[:frames]).to eq([[]] * 10)
      expect(response_data[:active]).to eq(true)
      expect(response_data[:bonus]).to eq([])
      expect(response_data[:score]).to eq([nil] * 10)
    end
  end

  describe 'POST #deliveries' do
    before(:each) do
      post :start
    end

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

      it 'creates deliveries' do
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
    end

    context 'with bonus frames' do
      it 'adds bonus delivery' do
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
    end
  end
end