require "thread"

puts "starting #{Process.pid}"
@children = []
@lock = Mutex.new

Signal.trap("USR1") do
  p @children
end


def do_fork
  if child = fork
    @lock.synchronize { @children << child }
    Thread.new do
      Process.wait(child)
      @lock.synchronize { @children.delete(child) }
    end
  else
    srand
    puts "child started #{Process.pid}"
    sleep(5 + rand(5))
    puts "child finished"
    exit!
  end
end

3.times { do_fork }
loop do
  sleep 0.5
end


