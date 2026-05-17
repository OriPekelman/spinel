Fiber[:user_id] = 42
puts Fiber[:user_id]

Fiber[:user_id] = 43
puts Fiber[:user_id]

# Unset key reads as nil.
v = Fiber[:not_set]
if v.nil?
  puts "nil_ok"
else
  puts "nil_unexpected"
end
