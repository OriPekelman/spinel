# spinel-dev#17. File.read on a missing path silently returned "" (and
# File.write to an un-openable path silently dropped the write; binread
# returned an empty byte array) instead of raising Errno::ENOENT like
# CRuby. The bogus "" flowed deep into programs until something
# dereferenced garbage — a no-output SIGSEGV far from the one-line
# cause. Now all three raise on open failure, with the strerror text
# and the rb_sysopen-style location CRuby uses.

# Success path stays a success path.
File.write("spinel_dev17_roundtrip.txt", "hello")
puts File.read("spinel_dev17_roundtrip.txt").length
File.delete("spinel_dev17_roundtrip.txt")

begin
  File.read("definitely_missing_spinel_dev17.txt")
  puts "no raise"
rescue => e
  puts "read raised"
  puts(e.message.include?("No such file or directory") ? "enoent" : e.message)
end

begin
  File.write("no_such_dir_spinel_dev17/x.txt", "d")
  puts "no raise"
rescue => e
  puts "write raised"
  puts(e.message.include?("No such file or directory") ? "enoent" : e.message)
end
