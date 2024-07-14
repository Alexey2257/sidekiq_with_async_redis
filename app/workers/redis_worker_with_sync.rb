class RedisWorkerWithSync
  include Sidekiq::Job

  def perform
    Sync do
      AsyncRedisClient.instance.with do |redis|
        redis.set('key', 'value')
      end
    end
  end
end
