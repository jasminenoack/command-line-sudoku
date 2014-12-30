class Sudoku
  attr_accessor :puzzle, :rotated

  def initialize(file)
    puzzle=File.open(file).read.split("\n")
    @puzzle=[]
    puzzle.each{|row| @puzzle << row.split("").map{|num| num=="0" ? "_" : num.to_i}}
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
    row=@puzzle[row]
    check(row)
  end

  def check_column(column)
    @rotate=rotate
    column=@rotated[column]
    check(column)
  end

  def find_square(row, column)
    start_h=(((row)/3)*3)
    start_v=(((column)/3)*3)
    square=[]
    (start_h..start_h+2).each do |row|
      (start_v..start_v+2).each do |column|
        square << [row, column]
      end
    end
    square
  end

  def check_square(row, column)
    places=find_square(row, column)
    square=[]
    places.each {|place| square << @puzzle[place[0]][place[1]]}
    check(square)
  end

  def check_place (row, column)
    return @puzzle[row][column] if @puzzle[row][column]!="_"
    check_row(row) & check_column(column) & check_square(row, column)
  end

  def solve_squares
    (0..8).each do |row|
      (0..8).each do |column|
        options=check_place(row, column)
        @puzzle[row][column]=options[0] if options.class==Array && options.length==1
      end
    end
    self
  end

  def check_incomplete
    incomplete=@puzzle.map {|row| row.count("_")}.inject(:+)
  end

  def find_options(places)
    options=[]
    places.each do |place|
      options << check_place(place[0],place[1])
    end
    options
  end

  def compare (options)
    nums=options.flatten.sort
    (1..9).each {|num| nums.delete(num) if nums.count(num)>1}
    nums
  end

  def update_from_compare(singles, options, places)
    singles.each do |num|
      if options.include?(num)
        next
      else
        options.each_with_index do |nums, index|
          next if nums.class==Fixnum
          if nums.include?(num)
            row = places[index][0]
            column = places[index][1]
            @puzzle[row][column]=num
          end
        end
      end
    end
  end

  def compare_row(row)
    rows=Array.new(9, row)
    columns=(0..8).to_a
    places=rows.zip(columns)
    options=find_options(places)
    singles=compare(options)
    update_from_compare(singles, options, places)
  end

  def compare_rows
    (0..8).each {|num| compare_row(num)}
  end

  def compare_column(column)
    columns=Array.new(9, column)
    rows=(0..8).to_a
    places=rows.zip(columns)
    options=find_options(places)
    singles=compare(options)
    update_from_compare(singles, options, places)
  end

  def compare_columns
    (0..8).each {|num| compare_column(num)}
  end

  def compare_square(row, column)
    places = find_square(row, column)
    options = find_options(places)
    singles = compare(options)
    update_from_compare(singles, options, places)
  end

  def compare_squares
    (0..2).each do |row|
      (0..2).each do |column|
        compare_square(row*3, column*3)
      end
    end
  end

  def complete_puzzle
    incomplete=check_incomplete
    while incomplete>0

      start=incomplete
      solve_squares
      incomplete=check_incomplete
      if incomplete == start
        compare_squares
        compare_rows
        compare_columns
        incomplete=check_incomplete
        if incomplete == start
          break
        end
      end
    end
    if incomplete > 0
      puts "I'm unfortunately unable to solve this puzzle"
      display
    else
      puts "I have solved the puzzle"
      display
    end
  end

end


class Guess_Puzzle < Sudoku
  initialize 
end

=begin
#can solve
puts 1
puzzle = Sudoku.new('puzzle1.txt')
puzzle.complete_puzzle
puts 2
puzzle = Sudoku.new('puzzle2.txt')
puzzle.complete_puzzle
puts 3
puzzle = Sudoku.new('puzzle3.txt')
puzzle.complete_puzzle
puts 4
puzzle = Sudoku.new('puzzle4.txt')
puzzle.complete_puzzle
puts 10
puzzle = Sudoku.new('puzzle10.txt')
puzzle.complete_puzzle
puts 11
puzzle = Sudoku.new('puzzle11.txt')
puzzle.complete_puzzle
=end


=begin
#can't solve
puts 5
puzzle = Sudoku.new('puzzle6.txt')
puzzle.complete_puzzle
puts 6
puzzle = Sudoku.new('puzzle5.txt')
puzzle.complete_puzzle
puts 7
puzzle = Sudoku.new('puzzle7.txt')
puzzle.complete_puzzle
puts 8
puzzle = Sudoku.new('puzzle8.txt')
puzzle.complete_puzzle
puts 9
puzzle = Sudoku.new('puzzle9.txt')
puzzle.complete_puzzle
puts 12
puzzle = Sudoku.new('puzzle12.txt')
puzzle.complete_puzzle
=end

puzzle = Sudoku.new('puzzle12.txt')
puzzle.complete_puzzle

# there are puzzles unsolvable by hand that now computer algorithms are being tested to solve. 