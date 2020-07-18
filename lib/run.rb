require_relative "main"

puts "Welcome to Disjointed Interval Program"
puts "Reading input_file.csv file......"

obj = Main.new
puts "Going to main process"

obj.process_data

puts "Output write into output_file.txt successfully !"
