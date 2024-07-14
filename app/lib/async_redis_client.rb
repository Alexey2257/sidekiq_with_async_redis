class AsyncRedisClient
  def self.instance
    Thread.current.thread_variable_get(:redis_client) ||
      Thread.current.thread_variable_set(:redis_client, new)
  end

  def initialize
    @client = Async::Redis::Client.new(Async::Redis.local_endpoint, limit: 10)
  end

  def with
    yield @client
  end
end
