class RedisWorker
  include Sidekiq::Job

  def perform
    tasks = 10000.times.map do
      Async do
        rand = Random.new.rand
        AsyncRedisClient.instance.with do |redis|
          redis.set(rand.to_s, rand.to_s)
        end
      end
    end
    tasks.map(&:wait)
  end
end
