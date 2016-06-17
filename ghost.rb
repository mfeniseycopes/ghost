require 'set'
require 'byebug'
require 'pry'

class Game
  attr_reader :dictionary, :players, :fragment, :working_dictionary

  GHOST = "GHOST"

  def initialize(player_1, player_2)
    # game vars
    @players = [player_1, player_2]
    @scores = { player_1 => 0, player_2 => 0 }
    @dictionary = Set.new
    @round = 1
    File.open( "dictionary.txt").each { |line| @dictionary << line.chomp }

    # for each round

  end

  # starts game of GHOST
  def run
    message_new_game
    until game_over?
      play_round
    end
    message_game_over
  end

  private

  def current_player
    @players.first
  end

  # prints all player scores to console
  def display_standings
    puts "STANDINGS"
    @scores.each do |player, score|
      puts "#{player} - #{score}"
    end
  end

  def game_over?
    # debugger
    @scores.count { |player, score| score == 5 } > 0
  end

  def message(&prc)
    system("clear")
    puts yield
    sleep(3)
  end

  def message_game_over
    message do
      "GAME OVER MAN!!! #{winner.name} WINS THE GAME!!\n"
       display_standings
    end
  end

  def message_new_game
    message { puts "Let's play #{GHOST}" }
  end

  def message_new_round
    message { puts "Begin round #{@round}!" }
  end

  def message_new_turn
    message do
      message { puts "Next Player... " } if @round != 1
      puts "FRAGMENT: #{@fragment}"
      puts "PLAYER: #{current_player}"
    end
  end

  def message_round_over
    message do
      puts "#{@fragment} is a word"
      puts "ROUND OVER MAN!!! #{previous_player} GETS A NEW LETTER!!"
      display_standings
    end
  end

  def next_player!
    @players.rotate!
  end

  def play_round
    # intialize empty fragment
    @fragment = ""
    # reset to full dictionary
    @working_dictionary = @dictionary

    # get user inputs until round over
    message_new_round
    until round_over?
      take_turn current_player

      # update dictionary
      @working_dictionary.select!{ |el| el.start_with? @fragment }

      # move play to next player
      next_player!
    end

    @scores[previous_player] += 1
  end

  def previous_player
    @players.last
  end

  def round_over?
    # debugger
    @working_dictionary.include?  @fragment
  end

  def record(player)
    GHOST[0, @scores[player]]
  end

  def take_turn(player)

    message_new_turn

    # gets input from current player
    guess = ""
    while true
      guess = player.guess
      if valid_play?(guess)
        break
      else
        player.alert_invalid_guess
      end
    end

    # updates fragment with player guess
    @fragment += guess

  end

  def valid_play?(string)
    return false unless !!string.match(/^[[:alpha:]]$/)

    working_dictionary.each do |el|
      return true if el.start_with? @fragment + string
    end
    false
  end

  def winner
    @scores.each { |player, score| return player if score != 5 }
  end
end

class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def alert_invalid_guess
    puts "Invalid play. Try again.\n"
  end

  def guess
    print "Enter a single letter: "
    guess = gets.strip
  end

  def to_s
    @name
  end

end

if __FILE__ == $PROGRAM_NAME
  if ARGV.shift == "pry"
    pry
  else
    player_1 = Player.new "Player 1"
    player_2 = Player.new "Player 2"
    game = Game.new(player_1, player_2)
    game.run
  end
end
