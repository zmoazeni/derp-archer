require "thread"

module DelayedJob
  class Worker < Qu::Worker
    def initialize(*)
      # should warn the user there is only 1 queue
      super
      @manager = Manager.new(5)
    end
    
    def work
      if @manager.available?
        logger.debug "Worker #{id} waiting for next job"
        job = Qu.reserve(self)
        if job
          if child_pid = fork
            @manager << child_pid
            Thread.new do
              Process.wait(child_pid)
              @manager.delete(child_pid)
              Qu.backend.completed(job)
            end
          else
            srand
            logger.debug "Worker #{id}:#{Process.pid} reserved job #{job}"
            job.perform
            logger.debug "Worker #{id}:#{Process.pid} completed job #{job}"
            exit!
          end
        end
      end
    end
    
    def start
      logger.warn "Worker #{id} starting"
      handle_signals
    
      loop { work; sleep 1 }
    rescue Abort => e
      # Ok, we'll shut down, but give us a sec
    ensure
      Qu.backend.unregister_worker(self)
      logger.debug "Worker #{id} done"
    end
  end
end
