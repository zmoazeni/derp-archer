require "qu"
require "leveldb"
require "multi_json"

require "delayed_job/backend"
require "delayed_job/worker"

module DelayedJob
  def self.enqueue(*args)
    Qu.enqueue(*args)
  end
end
