require "thread"

module DelayedJob
  class Worker < Qu::Worker
    def initialize(max_children=3, port=3000)
      super([])
      @port = port
      @manager = Manager.new(max_children)
    end
    
    def work
      if @manager.available?
        logger.debug "Worker #{id} waiting for next job"
        job = Qu.reserve(self)
        if job
          child_pid = fork do
            srand
            logger.debug "Worker #{id}:#{Process.pid} reserved job #{job}"
            job.perform
            logger.debug "Worker #{id}:#{Process.pid} completed job #{job}"
          end
          
          @manager << child_pid
          Thread.new do
            Process.wait(child_pid)
            @manager.delete(child_pid)
            Qu.backend.completed(job)
          end
        end
      end
    end
    
    def start
      logger.warn "Worker #{id} starting"
      handle_signals
      start_server
      loop { work; sleep 1 }
    rescue Abort => e
      # Ok, we'll shut down, but give us a sec
    ensure
      Qu.backend.unregister_worker(self)
      logger.debug "Worker #{id} done"
    end

    private
    def start_server
      Thread.new do
        Thin::Server.start('0.0.0.0', @port, {signals:false}) do
          run Server.new
        end
      end
    end
  end
end
