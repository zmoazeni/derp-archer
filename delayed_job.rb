require "qu"
require "leveldb"
require "multi_json"
require "sinatra"
require "thin"

require "delayed_job/backend"
require "delayed_job/manager"
require "delayed_job/worker"
require "delayed_job/server"

module DelayedJob
  def self.enqueue(*args)
    Qu.enqueue(*args)
  end

  def self.configure(*args, &block)
    Qu.backend = DelayedJob::Backend.new
    Qu.configure(*args, &block)
  end
end
