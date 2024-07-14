namespace :jobs do
  desc "Push jobs to the queue continuously"
  task push: :environment do
    loop do
      puts 'Pushing job to the queue'
      # RedisWorkerWithSync.perform_async # Works without patched sidekiq
      RedisWorker.perform_async
      sleep 1
    end
  end
end
