require 'csv'
class Main

	def initialize
		@input_file = CSV.parse(File.read("./executable/input_file.csv"), headers: true)
		@output_file = File.open("./executable/output_file.txt", "w")
		@out = []
	end

	def check_overlap(old_row, new_row)
		return [old_row[1], new_row[1]].min >= [old_row[0], new_row[0]].max
	end

	def add_interval(row)
		start_int = row["Start Interval"].to_i
		end_int = row["End Interval"].to_i
		len = @out.length
		new_arr = []
		if @out.count == 0 # if set is empty
			new_arr << [start_int, end_int]
		elsif end_int < @out[0][0] || start_int > @out[len-1][1] # check corners
			
			if end_int < @out[0][0]
				new_arr << [start_int, end_int]
			end

			for i in 0..len
				new_arr << @out[i]
			end

			if start_int > @out[len-1][1]
				new_arr << [start_int, end_int]
			end

		elsif start_int <= @out[0][0] && end_int >= @out[len-1][1] # existing intervals
			new_arr << [start_int, end_int]

		else  # check overlap and insert between
			overlap = true
			for i in 0...len
				overlap = check_overlap(@out[i], [start_int, end_int])
				if !overlap
					new_arr << @out[i]
					if i < len && start_int > @out[i][1] && end_int < @out[i+1][0]
						new_arr << [start_int, end_int]
						break
					end
				end

				temp_start_int = [start_int, @out[i][0]].min

				while i < len && overlap
					temp_end_int = [end_int, @out[i][1]].max
					if i == len-1
						overlap = false
					else
						overlap = check_overlap(@out[i+1], [start_int, end_int])
					end
					i+=1
				end
				new_arr << [temp_start_int, temp_end_int]

			end

		end

		@out = new_arr.uniq.compact
	end


	def add_interval_new(row)
		i = 0
		new_arr = []
		start = row["Start Interval"].to_i
		endt = row["End Interval"].to_i
		intervals = @out

		while (i < intervals.length() && intervals[i][1] < start) 
		  new_arr << intervals[i]
		  i = i+1
		end

		while (i < intervals.length() && intervals[i][0] <= endt) 
	    start = [start, intervals[i][0]].min
	    endt = [endt, intervals[i][1]].max
	    i+=1
		end
		new_arr << [start,endt]

		while (i < intervals.length) 
			new_arr << intervals[i]
			i = i+1
		end
		
		@out = new_arr
		

	end

	def remove_interval(row)
		start_int = row["Start Interval"].to_i
    end_int = row["End Interval"].to_i
    new_arr = []
    @out.each do |ty|
	    if ty[0] < start_int
	    	new_arr << [ty[0], [start_int, ty[1]].min]
	    end
	    if ty[1] > end_int
	      new_arr << [[end_int, ty[0]].max, ty[1]] 
	    end
	  end
	  @out = new_arr
	end


	def write_output_in_file(out_row)
		@output_file.write "#{out_row} \n"
	end

	def process_data
		@input_file.each do |row|
			case row["Action"]
			when "add"
				add_interval_new(row)
			when "remove"
				remove_interval(row)
			end
			write_output_in_file(@out)
		end
		@output_file.close()
	end

end
