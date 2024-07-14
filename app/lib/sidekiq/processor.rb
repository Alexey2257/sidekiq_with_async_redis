# frozen_string_literal: true

module Sidekiq
  class Processor
    def run
      # By setting this thread-local, Sidekiq.redis will access +Sidekiq::Capsule#redis_pool+
      # instead of the global pool in +Sidekiq::Config#redis_pool+.
      Thread.current[:sidekiq_capsule] = @capsule

      Sync do
        process_one until @done
      end
      @callback.call(self)
    rescue Sidekiq::Shutdown
      @callback.call(self)
    rescue Exception => ex
      @callback.call(self, ex)
    end
  end
end
