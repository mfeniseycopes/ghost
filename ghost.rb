require 'set'
require 'byebug'
require 'pry'

class Game
  attr_reader :dictionary, :players, :fragment, :working_dictionary

  GHOST = "GHOST"

  def initialize(player_1, player_2)

    @players = [player_1, player_2]
    @scores = { player_1 => 0, player_2 => 0 }
    @dictionary = File.open( "dictionary.txt").readlines.map(&:chomp)

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
    @scores.count { |player, score| score == 5 } > 0
  end

  def message(wait = 1, &prc)
    system("clear")
    puts yield
    sleep(wait)
  end

  def message_game_over
    message(2) do
      "GAME OVER MAN!!! #{winner.name} WINS THE GAME!!"
       display_standings
    end
  end

  def message_new_game
    message { puts "Let's play #{GHOST}" }
  end

  def message_new_round
    message { puts "Begin round #{round}!" }
  end

  def message_new_turn
    message { puts "Next Player... " } if @fragment.length != 0
    message do
      puts "#{record(current_player)}: #{current_player}"
      puts "working on: #{@fragment}"
    end
  end

  def message_round_over
    message(5) do
      puts "'#{@fragment}' is a word."
      puts "ROUND OVER MAN!!! #{previous_player} is becoming a ghost!!"
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
    @working_dictionary = @dictionary.dup

    # get user inputs until round over
    message_new_round

    until round_over?
      take_turn current_player

      # update dictionary
      @working_dictionary.select!{ |el| el.start_with? @fragment }

      # move play to next player
      next_player!
    end

    # updates user with standings
    message_round_over

    # post round data management
    @scores[previous_player] += 1
  end

  def previous_player
    @players.last
  end

  def round_over?
    @working_dictionary.size == 0 || @working_dictionary.include?(@fragment)
  end

  def round
    @scores.values.reduce(1, :+)
  end

  def record(player)
    letters = GHOST[0, @scores[player]]
    spaces = "_" * (GHOST.length - @scores[player])
    letters + spaces
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

  def valid_play?(user_input)
    return false unless user_input.between?("a", "z")

    @working_dictionary.each do |el|
      return true if el.start_with? @fragment + user_input
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
