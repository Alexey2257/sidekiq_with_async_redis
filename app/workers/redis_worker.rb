class RedisWorker
  include Sidekiq::Job

  def perform
    AsyncRedisClient.instance.with do |redis|
      redis.set('key', 'value')
    end
  end
end
