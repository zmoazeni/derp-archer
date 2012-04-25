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
  c.connection = "./db"
  c.logger.level = Logger::DEBUG
end

DelayedJob::Worker.new(5, 3001).start
