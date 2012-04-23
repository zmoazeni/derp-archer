module DelayedJob
  class Worker < Qu::Worker
    def work
      logger.debug "Worker #{id} waiting for next job"
      job = Qu.reserve(self)
      logger.debug "Worker #{id} reserved job #{job}"
      job.perform
      logger.debug "Worker #{id} completed job #{job}"
    end
  end
end
