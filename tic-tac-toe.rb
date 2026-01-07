### Player
class Player
  attr_accessor :name
  
  def initialize(name)
    @name = name
  end
end


### Board
class Board
  BOARD_POS_NUM = "0 | 1 | 2\n---------\n3 | 4 | 5\n---------\n6 | 7 | 8"
  attr_accessor :filled_positions

  def initialize
    @filled_positions = Array.new(9)
  end

  def show_board_numbers()
    return BOARD_POS_NUM
  end

  def show_current_board()
    board = ""

    BOARD_POS_NUM.each_char do |char|
      pos = Integer(char, exception: false)
      if pos != nil
        if @filled_positions[pos] != nil
          board << filled_positions[pos]
        else
          board << " "
        end
      else
        board << char
      end
    end

    return board
  end
  
  # Position is like dis:
  # 0 | 1 | 2
  # 3 | 4 | 5
  # 6 | 7 | 8
  def set_position(pos, shape_type)
    @filled_positions[pos] = shape_type
  end

  def valid_move(pos)
    return (0..9).include?(pos) && @filled_positions[pos] == nil
  end

  def is_game_over()
    return is_victory || is_tie
  end

  def is_victory()
    if @filled_positions[0] != nil && @filled_positions[0] == @filled_positions[1] &&  @filled_positions[0] == @filled_positions[2]
      return true
    elsif @filled_positions[0] != nil && @filled_positions[0] == @filled_positions[3] &&  @filled_positions[0] == @filled_positions[6]
      return true
    elsif @filled_positions[0] != nil && @filled_positions[0] == @filled_positions[4] &&  @filled_positions[0] == @filled_positions[8]
      return true
    elsif @filled_positions[1] != nil && @filled_positions[1] == @filled_positions[4] &&  @filled_positions[1] == @filled_positions[7]
      return true
    elsif @filled_positions[2] != nil && @filled_positions[2] == @filled_positions[5] &&  @filled_positions[2] == @filled_positions[8]
      return true
    elsif @filled_positions[2] != nil && @filled_positions[2] == @filled_positions[4] &&  @filled_positions[2] == @filled_positions[6]
      return true
    elsif @filled_positions[3] != nil && @filled_positions[3] == @filled_positions[4] &&  @filled_positions[3] == @filled_positions[5]
      return true
    elsif @filled_positions[6] != nil && @filled_positions[6] == @filled_positions[7] &&  @filled_positions[6] == @filled_positions[8]
      return true
    end

    return false  
  end

  def is_tie()
    return @filled_positions.all? {|element| element != nil}
  end
end

module Shape
  NAUGHTS = "O"
  CROSSES = "X"
end

class TicTacToe
  def initialize
    @board = Board.new
    @player_O = Player.new("Player O")
    @player_X = Player.new("Player X")
  end

  def start_play
    shape_type = Shape::CROSSES
    # Play until the game is overrr!
    puts "The position number should follow the board below!"
    puts @board.show_board_numbers
    puts "Are you ready? Okay! I'm starting anyways~~~~~\n\n"

    until @board.is_game_over do
      shape_type = shape_type == Shape::NAUGHTS ? Shape::CROSSES : Shape::NAUGHTS
      prompt_enter_position(shape_type)
      puts "Current board:"
      puts @board.show_current_board
    end
    if @board.is_tie
      puts "Game is over! It's a tie!"
    else
      puts "Game is over! The winner is... *drum roll*"
      player_name = shape_type == Shape::NAUGHTS ? @player_O.name : @player_X.name
      puts player_name + "!!!"
    end
  end

  def prompt_enter_position(shape_type)
    puts "\n=============================================================\n"
    player_name = shape_type == Shape::NAUGHTS ? @player_O.name : @player_X.name
    puts "\n" + player_name + ", Please enter your position: "
    pos = gets.chomp.to_i
    until (@board.valid_move(pos)) do
      puts "Invalid input!"
      puts player_name + ", Please enter your position: "
      pos = gets.chomp.to_i
    end

    @board.set_position(pos, shape_type) 
  end

end

game = TicTacToe.new
game.start_play