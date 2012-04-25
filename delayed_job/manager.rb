module DelayedJob
  class Manager
    def initialize(max_children)
      @max_children = max_children
      @children = []
      @lock = Mutex.new
    end

    def available?
      @lock.synchronize { @children.size < @max_children }
    end

    def << (pid)
      @lock.synchronize { @children << pid }
    end

    def delete(pid)
      @lock.synchronize { @children.delete(pid) }
    end
  end
end
