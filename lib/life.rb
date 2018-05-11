class Board
  attr_accessor :array, :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @array = Array.new(@width) do
      Array.new(@height) { Cell.new(rand(0..1)) }
    end
  end

  def reset
    @array.each do |row|
      row.each { |cell| cell.id = 0 }
    end
  end

  def display
    @array.each do |row|
      row.each { |cell| print cell.id }
      print "\n"
    end
  end
end

class Cell
  attr_accessor :id

  def initialize(id)
    @id = id
  end

  def is_alive?
    if @id != 0
      return true
    end
    return false
  end

  def dies
    @id = 0
  end

  def resuscitates
    @id = 1
  end
end

class Game
  attr_reader :board

  def initialize(board)
    @board = board
    @temp_board = Marshal::load(Marshal.dump(board))
    @temp_board.reset
  end

  def play(loop_size)
    loop_size.times do
      thick
      @board = Marshal::load(Marshal.dump(@temp_board))
      @board.display
      @temp_board.reset
      sleep 0.5
      system('clear')
    end
  end

  def thick
    @board.array.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        neighborhood = get_neighborhood(x, y)
        if cell.is_alive?
          if deserves_to_die?(neighborhood)
            @temp_board.array[y][x].dies
          else
            @temp_board.array[y][x].id = 1
          end
        else
          if deserves_to_revive?(neighborhood)
            @temp_board.array[y][x].resuscitates
          else
            @temp_board.array[y][x].id = 0
          end
        end
      end
    end
  end

  private
  def get_neighborhood(x, y)
    neighborhood = Array.new
    coordinates = { x: x - 1, y: y - 1 }
    3.times do
      3.times do
        if outter_coordinates?(coordinates)
          neighborhood << Cell.new(0)
        else
          if coordinates[:x] == x && coordinates[:y] == y
            coordinates[:x] += 1
            next
          end
          neighborhood.push(board.array[coordinates[:y]][coordinates[:x]])
        end
        coordinates[:x] += 1
      end
      coordinates[:x] = x -1
      coordinates[:y] += 1
    end

    return neighborhood
  end

  def outter_coordinates?(coordinates)
    if coordinates[:x] < 0 || coordinates[:x] > board.width - 1 || coordinates[:y] < 0 || coordinates[:y] > board.height - 1
      return true
    end

    return false
  end

  def deserves_to_die?(neighborhood)
    points = 0
    neighborhood.each { |cell| points += 1 if cell.is_alive? }
    return true if points < 2 || points > 3
    return false if points == 2 || points == 3
  end

  def deserves_to_revive?(neighborhood)
    points = 0
    neighborhood.each { |cell| points += 1 if cell.is_alive? }
    return true if points == 3

    return false
  end
end

class Life
  def self.start
    puts 'Conway\'s Game of Life - JJaimelr version'
    puts 'WELCOME'
    puts 'Please choose an option to watch the game in action'
    puts '[1] random'
    puts '[2] pattern'
    option = gets.chomp.to_s
    case option
    when 'random', '1'
      puts 'Enter the loop size'
      loop_size = gets.chomp.to_i
      board = Board.new(40, 40)
      blinkerBoard = Board.new(5, 5)
      board.display
      game = Game.new(board)
      game.play loop_size
    when 'pattern', '2'
      self.watch_pattern
    else
      puts '*Confused* Do you enter the number (or name) of the option? If so, could you please try again?'
    end
  end

  def self.watch_pattern
    puts 'Enter the name or the number of the pattern'
    puts '[1] blinker'
    puts '[2] beacon'
    puts '[3] block'
    puts '[4] pulsar'
    puts '[5] glider'
    pattern = gets.chomp
    puts 'Enter the loop size'
    loop_size = gets.chomp.to_i
    case pattern
    when 'blinker', '1'
      board = Board.new(5, 5)
      board.reset
      board.array[2][1] = Cell.new(1)
      board.array[2][2] = Cell.new(1)
      board.array[2][3] = Cell.new(1)
    when 'beacon', '2'
      board = Board.new(6, 6)
      board.reset
      board.array[1][1] = Cell.new(1)
      board.array[1][2] = Cell.new(1)
      board.array[2][1] = Cell.new(1)
      board.array[4][3] = Cell.new(1)
      board.array[4][4] = Cell.new(1)
      board.array[3][4] = Cell.new(1)
    when 'block', '3'
      board = Board.new(4, 4)
      board.reset
      board.array[1][1] = Cell.new(1)
      board.array[1][2] = Cell.new(1)
      board.array[2][1] = Cell.new(1)
      board.array[2][2] = Cell.new(1)
    when 'pulsar', '4'
      board = Board.new(6, 6)
      board.reset
      board.array[2][2] = Cell.new(1)
      board.array[2][3] = Cell.new(1)
      board.array[2][4] = Cell.new(1)
      board.array[3][1] = Cell.new(1)
      board.array[3][2] = Cell.new(1)
      board.array[3][3] = Cell.new(1)
    when 'glider', '5'
      board = Board.new(20, 20)
      board.reset
      board.array[1][2] = Cell.new(1)
      board.array[2][3] = Cell.new(1)
      board.array[3][1] = Cell.new(1)
      board.array[3][2] = Cell.new(1)
      board.array[3][3] = Cell.new(1)
      board.display
    else
      puts 'Pattern not found'
    end
    game = Game.new(board)
    board.display
    game.play loop_size
  end
end

Life.start
