require "delayed_job"

class MyJob
  def self.perform(id)
    puts "In MyJob #{id}"
  end
end

Qu.configure do |c|
  c.backend = DelayedJob::Backend.new
  c.connection = "./db"
end

DelayedJob.enqueue(MyJob, 1)
DelayedJob::Worker.new.work_off

DelayedJob.enqueue(MyJob, 2)
DelayedJob.enqueue(MyJob, 3)
DelayedJob::Worker.new.work_off
