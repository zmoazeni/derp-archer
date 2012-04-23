module DelayedJob
  class Backend < Qu::Backend::Base
    alias_method :db_path, :connection
    
    def queue
      @queue ||= LevelDB::DB.new("#{db_path}/queue.ldb")
    end

    def running
      @running ||= LevelDB::DB.new("#{db_path}/running.ldb")
    end

    def failed
      @failed ||= LevelDB::DB.new("#{db_path}/failed.ldb")
    end
    
    def queues
      "default"
    end

    def length
      queue.keys.size
    end
      
    def enqueue(payload)
      queue[Time.now.to_f.to_s] = MultiJson.dump(klass:payload.klass.to_s, args:payload.args)
    end

    def reserve(_, options = {block:false})
      loop do
        logger.debug { "Reserving job in queue #{queue}" }

        if raw = queue.first
          id, job = raw
          queue.delete(id)
          running[id] = job
          return Qu::Payload.new(MultiJson.load(job).update(id:id))
        end

        if options[:block]
          sleep poll_frequency
        else
          break
        end
      end
    end

    def completed(payload)
      running.delete(payload.id)
    end

    def failed(payload, e)
      running.delete(payload.id)
      # save to the failed_db
    end

    def release(payload)
      running.delete(payload.id)
      queue[payload.id] = MultiJson.dump(klass:payload.klass.to_s, args:payload.args)
    end
  end
end
