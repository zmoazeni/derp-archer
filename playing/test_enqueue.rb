require "delayed_job"

class MyJob
  def self.perform(id)
    sleep(rand(5) + 1)
    puts "In MyJob #{id}"
    if id == 8 || id == 1
      puts "Erroring #{id}"
      raise "what the heck?"
    end
  end
end

DelayedJob.configure do |c|
#  c.backend = DelayedJob::Backend.new
  c.connection = "./db"
  c.logger.level = Logger::DEBUG
end

worker = DelayedJob::Worker.new(5)

10.times do |i|
  DelayedJob.enqueue(MyJob, i)
end

# worker.work_off # also works
worker.start
