trap("CHLD") do
  puts "a child died"
end

fork do
  puts "in child"
end

fork do
  puts "in child2"
end

sleep 4
