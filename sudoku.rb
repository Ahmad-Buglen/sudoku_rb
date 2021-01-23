=begin
rate moddle
"[ [0,0,0,0,0,0,0,0,9],
	[0,0,0,0,0,0,0,0,6],
	[0,0,0,0,0,0,1,2,3], 
	[0,0,0,0,0,5,9,6,7], 
	[0,0,7,3,1,2,8,4,5], 
	[0,0,5,0,0,0,0,0,2], 
	[0,0,1,5,7,4,6,9,8], 
	[0,0,8,2,3,0,5,0,4], 
	[0,0,0,9,0,8,0,3,0] ]"

rate expert
"[ [0,7,2,0,0,5,0,0,0],
	[9,0,0,0,0,0,0,8,0],
	[0,0,0,0,7,0,0,0,0], 
	[0,0,0,2,0,0,3,0,5], 
	[3,0,0,0,1,0,7,0,0], 
	[0,0,0,0,0,4,8,0,0], 
	[1,0,0,0,0,6,0,0,9], 
	[0,0,6,1,0,0,0,0,0], 
	[0,0,0,3,4,0,0,0,2] ]"

rate hard
"[ [2,0,0,4,0,0,8,0,0],
	[0,8,0,3,0,0,6,0,0],
	[0,0,3,0,0,0,0,0,0], 
	[0,0,0,0,2,9,0,0,1], 
	[0,0,9,0,5,1,0,0,6], 
	[0,6,0,0,0,3,9,0,2], 
	[0,0,0,0,0,0,0,7,0], 
	[0,4,0,0,8,0,0,0,0], 
	[1,9,0,0,0,0,0,4,0] ]"
=end

require 'json'

MIN = 0..2
MID = 3..5
MAX = 6..8
UNDEFINE = 0
$solution = 0

def exit_sudoku(err_str)
	puts err_str
	exit
end

def gorizont_check(mas, line)
	0.upto 8 do |i|
		(i + 1).upto 8 do |j|
			if ((mas[line][i] == mas[line][j]) && (mas[line][i] != UNDEFINE))
				return false
			end
		end
	end
	return true
end

def vert_check(mas, сcolumn)
	0.upto 8 do |i|
		(i + 1).upto 8 do |j|
			if ((mas[i][сcolumn] == mas[j][сcolumn]) && (mas[i][сcolumn] != UNDEFINE))
				return false
			end
		end
	end
	return true
end

def square_limits(index)
	case index
		when MIN
			return MIN.min, MIN.max
		when MID
			return MID.min, MID.max
		when MAX
			return MAX.min, MAX.max
	end
end

def square_check(mas, i, j)
	from_i, to_i = square_limits(i)
	from_j, to_j = square_limits(j)
	square_values = []
	from_i.upto to_i do |ii|
		from_j.upto to_j do |jj|
			square_values.push(mas[ii][jj])
		end
	end
	square_values.delete UNDEFINE
	if (square_values.size != square_values.uniq.size)
		return false
	end
	return true
end

def sudoku_print(mas)
	puts 
	mas.each {|column| puts column.inspect}
end

def sudoku_check(mas)
	rezult = true
	9.times do |x| 
		rezult = (gorizont_check(mas, x) && vert_check(mas, x) && square_check(mas, x, x)) ? rezult : false;
	end
	return rezult
end

def search_zero(mas)
	0.upto 8 do |i|
		0.upto 8 do |j|
			if (0 == mas[i][j])
				return i, j
			end
		end
	end
	return nil
end

def possible_values(mas, i, j)
	values = []
	1.upto 9 do |val|
		mas[i][j] = val
		if (square_check(mas, i, j) && gorizont_check(mas, i) && vert_check(mas, j))
			values.push(val)
		end
		mas[i][j] = UNDEFINE
	end
	if (0 == values.size)
		return nil
	end
	return values
end

def recursive_search(mas)
	i, j = search_zero(mas)
	if (nil == i)
		sudoku_print(mas)
		$solution += 1
		return nil
	end
	values = possible_values(mas, i, j)
	if (nil == values)
		return nil
	end
	values.each do |val|
		duplicate = Marshal.load(Marshal.dump(mas))
		duplicate[i][j] = val
		recursive_search(duplicate)
	end
end

mas = JSON.parse ARGV[0]

if (mas.class != Array)
	exit_sudoku("Couldn't read the array")
elsif (false == sudoku_check(mas))
	exit_sudoku("Invalid input params")
end

recursive_search(mas)

if (0 == $solution)
	exit_sudoku("Invalid input params or sudoku don't solution")
end
