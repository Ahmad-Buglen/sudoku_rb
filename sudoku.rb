# frozen_string_literal: true

# rate moddle
# "[  [0,0,0,0,0,0,0,0,9],
# 	[0,0,0,0,0,0,0,0,6],
# 	[0,0,0,0,0,0,1,2,3],
# 	[0,0,0,0,0,5,9,6,7],
# 	[0,0,7,3,1,2,8,4,5],
# 	[0,0,5,0,0,0,0,0,2],
# 	[0,0,1,5,7,4,6,9,8],
# 	[0,0,8,2,3,0,5,0,4],
# 	[0,0,0,9,0,8,0,3,0] ]"
#
# rate expert
# "[  [0,7,2,0,0,5,0,0,0],
# 	[9,0,0,0,0,0,0,8,0],
# 	[0,0,0,0,7,0,0,0,0],
# 	[0,0,0,2,0,0,3,0,5],
# 	[3,0,0,0,1,0,7,0,0],
# 	[0,0,0,0,0,4,8,0,0],
# 	[1,0,0,0,0,6,0,0,9],
# 	[0,0,6,1,0,0,0,0,0],
# 	[0,0,0,3,4,0,0,0,2] ]"
#
# rate hard
# "[  [2,0,0,4,0,0,8,0,0],
# 	[0,8,0,3,0,0,6,0,0],
# 	[0,0,3,0,0,0,0,0,0],
# 	[0,0,0,0,2,9,0,0,1],
# 	[0,0,9,0,5,1,0,0,6],
# 	[0,6,0,0,0,3,9,0,2],
# 	[0,0,0,0,0,0,0,7,0],
# 	[0,4,0,0,8,0,0,0,0],
# 	[1,9,0,0,0,0,0,4,0] ]"

require 'json'

MIN = (0..2).freeze
MID = (3..5).freeze
MAX = (6..8).freeze
UNDEFINE = 0
$solution = 0

def exit_sudoku(err_str)
  puts err_str
  exit
end

def gorizont_check(mas, line)
  0.upto 8 do |i|
    (i + 1).upto 8 do |j|
      return false if (mas[line][i] == mas[line][j]) && (mas[line][i] != UNDEFINE)
    end
  end
  true
end

def vert_check(mas, column)
  0.upto 8 do |i|
    (i + 1).upto 8 do |j|
      return false if (mas[i][column] == mas[j][column]) && (mas[i][column] != UNDEFINE)
    end
  end
  true
end

def square_limits(index)
  case index
  when MIN
    MIN.minmax
  when MID
    MID.minmax
  when MAX
    MAX.minmax
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
  return false if square_values.size != square_values.uniq.size

  true
end

def sudoku_print(mas)
  puts
  mas.each { |column| puts column.inspect }
end

def sudoku_check(mas)
  rezult = true
  9.times do |x|
    rezult = gorizont_check(mas, x) && vert_check(mas, x) && square_check(mas, x, x) ? rezult : false
  end
  rezult
end

def search_zero(mas)
  0.upto 8 do |i|
    0.upto 8 do |j|
      return i, j if (mas[i][j]).zero?
    end
  end
  nil
end

def possible_values(mas, i, j)
  values = []
  1.upto 9 do |val|
    mas[i][j] = val
    values.push(val) if square_check(mas, i, j) && gorizont_check(mas, i) && vert_check(mas, j)
    mas[i][j] = UNDEFINE
  end
  return nil if values.size.zero?

  values
end

def recursive_search(mas)
  i, j = search_zero(mas)
  if i.nil?
    sudoku_print(mas)
    $solution += 1
    return nil
  end
  values = possible_values(mas, i, j)
  return nil if values.nil?

  values.each do |val|
    duplicate = Marshal.load(Marshal.dump(mas))
    duplicate[i][j] = val
    recursive_search(duplicate)
  end
end

mas = JSON.parse ARGV[0]

if mas.class != Array
  exit_sudoku("Couldn't read the array")
elsif sudoku_check(mas) == false
  exit_sudoku('Invalid input params')
end

recursive_search(mas)

exit_sudoku("Invalid input params or sudoku don't solution") if $solution == 0
