class Sudoku
  attr_accessor :puzzle, :rotated

  def initialize(puzzle)
    @puzzle=Array.new(81, "_").each_slice(9).to_a
    puzzle.each do |key, value|
      key=key.split("").map{|x| x.to_i}
      @puzzle[key[0]-1][key[1]-1]=value
    end
  end

  def display
    @puzzle.each_with_index do |row, index|
      puts "---------------------" if index==3 || index==6
      puts "#{row[0]} #{row[1]} #{row[2]} | #{row[3]} #{row[4]} #{row[5]} | #{row[6]} #{row[7]} #{row[8]}"
    end
    puts
  end

  def rotate
    @rotated = Array.new(81, "_").each_slice(9).to_a
    (0..8).each do |column|
      (0..8).each do |row|
        @rotated[row][column]=@puzzle[column][row]
      end
    end
    @rotated
  end

  def check(nums)
    possible=[]
    (1..9).each {|num| possible << num if !nums.include?(num) }
    possible
  end

  def check_row(row)
    row=@puzzle[row-1]
    check(row)
  end

  def check_column(column)
    @rotate=rotate
    column=@rotated[column-1]
    check(column)
  end

  def find_square(row, column)
    start_h=(((row-1)/3)*3)
    start_v=(((column-1)/3)*3)
    square=[]
    (start_h..start_h+2).each do |row|
      (start_v..start_v+2).each do |column|
        square << @puzzle[row][column]
      end
    end
    square
  end

  def check_square(row, column)
    square=find_square(row, column)
    check(square)
  end

  def check_place (row, column)
    return @puzzle[row-1][column-1] if @puzzle[row-1][column-1]!="_"
    check_row(row) & check_column(column) & check_square(row, column)
  end

  def solve_squares
    (1..9).each do |row|
      (1..9).each do |column|
        options=check_place(row, column)
        @puzzle[row-1][column-1]=options[0] if options.class==Array && options.length==1
      end
    end
    self
  end

end










puzzle = Sudoku.new({"12" => 4, "13" => 5, "14" => 8, "16" => 3, "17" => 7, "18" => 1, "21" => 8, "22" => 1, "28" => 2, "29" => 4, "31" => 7, "33" => 9, "37" => 5, "39" => 8,"44" => 9, "46" => 7,"55" => 6, "64" => 4, "66" => 2, "71" => 6, "73" => 4, "77" => 3, "79" => 5, "81" => 3, "82" => 2, "88" => 8, "89" => 7, "92" => 5, "93" => 7, "94" => 3, "96" => 8, "97" => 2, "98" => 6})
# print puzzle.check_row(1)
# print puzzle.check_column(1)
# print puzzle.check_square(1,1)
# print puzzle.puzzle
# puts
# print puzzle.rotate
puzzle.display
puts
puts 
puzzle.solve_squares.display
puts 
puts
puzzle.solve_squares.display
puts 
puts
puzzle.solve_squares.display
puts 
puts
puzzle.solve_squares.display
puts 
puts
puzzle.solve_squares.display
puts 
puts
puzzle.solve_squares.display