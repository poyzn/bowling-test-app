module Games
  class GameController < ApplicationController
    def start
      game.start
      render json: { status: 'success', data: { message: 'Game is started!' } }
    end

    def show
      render json: { status: 'success', data: status.as_json }
    end

    def deliveries
      game.add_delivery params[:pins]
      render json: { status: 'success', data: status.as_json }
    end

    private

    def storage
      Storages::RedisStorage.new
    end

    def game
      @game ||= Repositories::GameRepository.new(storage)
    end

    def status
      Presenters::GamePresenter.new(game)
    end
  end
end
