require 'json'


# valid "[[1,2,3,4,5,6,7,8,9], [7,8,9,1,2,3,4,5,6], [4,5,6,7,8,9,1,2,3], [3,1,2,8,4,5,9,6,7], [6,9,7,3,1,2,8,4,5], [8,4,5,6,9,7,3,1,2], [2,3,1,5,7,4,6,9,8], [9,6,8,2,3,1,5,7,4], [5,7,4,9,6,8,2,3,1]]"

# invalid "[[1,2,3,4,5,6,7,8,9], [7,8,9,1,2,3,4,5,6], [4,5,6,7,8,9,1,2,3], [3,1,2,8,4,5,9,6,7], [6,9,7,3,1,2,8,4,5], [8,4,5,6,9,7,3,1,2], [2,3,1,5,7,4,6,9,8], [9,6,8,2,3,1,5,7,4], [5,7,4,9,6,8,2,3,100]"

def exit_sudoku(err_str)
	puts err_str
	exit
end

def gorizont_check(mas, line)
	i = 0;
	while (i < 9) do
		j = i + 1
		while (j < 9) do
			if ((mas[line][i] == mas[line][j]) && (mas[line][i] != 0))
				exit_sudoku("invalid line")
			end
			j += 1
		end
		i += 1
	end
	# mas[line].each do |elem| 

	# 		if mas[line][i] == mas[line][j]
	# 			exit_sudoku("invalid line")
	# 		end
	# 	end
	# end

	# для нулей не подходит 
	# if  mas[line].uniq.length != mas[line].length
	# 	exit_sudoku("invalid line")
	# end
end

def vert_check(mas, сcolumn)
	i = 0;
	while (i < 9) do
		j = i + 1
		while (j < 9) do
			if ((mas[i][сcolumn] == mas[j][сcolumn]) && (mas[i][сcolumn] != 0))
				exit_sudoku("invalid column")
			end
			j += 1
		end
		i += 1
	end
	
end

def digital_check(mas)
	mas.each do |column|  
		column.each do |elem|  
			if ((elem < 0) || (9 < elem))
				exit_sudoku("invalid digital")
			end
		end
	end
end

def square_check(mas, i, j)
	# i += 1;
	# j += 1;
	# from_i =  i % 3 == 0 ?  i - 3 : i - (i % 3)
	# to_i =  i % 3 == 0 ?  i - 1 : i + (i % 3)
	case i
		when 0..2
			from_i = 0
			to_i = 2
		when 3..5
			from_i = 3
			to_i = 5
		when 6..8
			from_i = 6
			to_i = 8
	end
	case j
		when 0..2
			from_j = 0
			to_j = 2
		when 3..5
			from_j = 3
			to_j = 5
		when 6..8
			from_j = 6
			to_j = 8
	end
	buff = []
	while (from_i <= to_i) do
		while (from_j <= to_j) do
			buff.push(mas[from_i][from_j])
			from_j += j
		end
		from_i += 1
	end

	buff.each_with_index do |val, index|
		buff.drop(index + 1).each do |value| 
			if (val == value)
				exit_sudoku("invalid square")
			end
		end
	end
end

def sudoku_check(mas)
	
end

mas = JSON.parse ARGV[0]

if (mas.class != Array)
	exit_sudoku("Couldn't read the array")
end 

9.times do |x| 
	gorizont_check(mas, x)
	vert_check(mas, x)
end


digital_check(mas)
square_check(mas, 0, 0)
square_check(mas, 3, 0)
square_check(mas, 6, 0)
square_check(mas, 0, 3)
square_check(mas, 0, 6)
square_check(mas, 3, 3)
square_check(mas, 3, 6)
square_check(mas, 6, 3)
square_check(mas, 6, 6)

# print mas.inspect




