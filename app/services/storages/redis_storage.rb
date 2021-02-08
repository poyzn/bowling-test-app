module Storages
  class RedisStorage
    KEY = 'game'

    def initialize
      @redis = REDIS_CONNECTION
    end

    def read
      JSON.parse(@redis.get KEY).symbolize_keys
    end

    def write(value)
      @redis.set KEY, value.to_json
    end
  end
end
