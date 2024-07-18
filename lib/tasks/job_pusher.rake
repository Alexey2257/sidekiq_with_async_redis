namespace :jobs do
  desc "Push jobs to the queue continuously"
  task push: :environment do
    loop do
      puts 'Pushing job to the queue'
      # RedisWorkerWithSync.perform_async # Works without patched sidekiq
      20.times do
        RedisWorker.perform_async
      end
      sleep 1
    end
  end
end
