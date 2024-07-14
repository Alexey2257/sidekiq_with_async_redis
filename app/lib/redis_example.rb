require 'async/redis'

endpoint = Async::Redis.local_endpoint
@client = Async::Redis::Client.new(endpoint)

Sync do
  @client.set('key', 'value')
  puts @client.get('key') # => "value"
ensure
  @client.close
end
