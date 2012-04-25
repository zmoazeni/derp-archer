puts "Parent: #{Process.pid}"
child = fork do
  sleep 2
  puts "Child: #{Process.pid}"
end

p "in here #{Process.pid} #{child}"
Process.wait child
