trap("INT") do |x|
  puts "Sleeping #{Thread.current.inspect}"
  sleep 10
  p x
  p x.class
#  STDERR.puts "sub pid #{$$} Control-C"
  exit 2
end

puts "#{$$}"
STDOUT.flush
sleep 10
