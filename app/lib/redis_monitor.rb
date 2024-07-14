require 'async'
require 'async/redis'
require 'tty-sparkline'
require 'tty-screen'

endpoint = Async::Redis.local_endpoint
redis = Async::Redis::Client.new(endpoint)

connection_counts = []

interval = 1
max_width = TTY::Screen.width - 20

Sync do
  initial_connections_count = redis.info[:total_connections_received].to_i

  Async do |task|
    loop do
      new_connections = redis.info[:total_connections_received].to_i - initial_connections_count

      connection_counts << new_connections

      if connection_counts.size > max_width
        connection_counts.shift
      end

      task.sleep(interval)
    end
  end

  Async do |task|
    loop do
      print "\e[H\e[2J" # Clear the screen

      puts "Redis Connection Monitoring"
      puts "Total created connections: #{connection_counts.last}"

      sparkline = TTY::Sparkline.new(connection_counts, width: max_width, height: 10)
      puts sparkline.render

      task.sleep(interval)
    end
  end
end
