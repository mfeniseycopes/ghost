require 'set'
require 'byebug'

class Game
  attr_reader :dictionary, :players, :fragment, :working_dictionary

  GHOST = "GHOST"

  def initialize(player_1, player_2)
    # game vars
    @players = [player_1, player_2]
    @scores = { player_1 => 0, player_2 => 0 }
    @dictionary = Set.new
    @rounds = 0
    File.open( "dictionary.txt").each { |line| @dictionary << line.chomp }

    # for each round
    @fragment = ""
    @working_dictionary = @dictionary
  end

  # starts game of GHOST
  def run
    message_new_game
    unless game_over?
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
    @scores.count { |player, score| score != 5 } == 1
  end

  def message_game_over
    puts "GAME OVER MAN!!! #{winner.name} WINS THE GAME!!"
    display_standings
  end

  def message_new_game
    puts "Let's play #{GHOST}"
  end

  def message_new_round
    puts "Begin round #{@round}!"
  end

  def message_round_over
    puts "#{fragment} is a word"
    puts "ROUND OVER MAN!!! #{previous_player} GETS A NEW LETTER!!"
    display_standings
  end

  def next_player!
    @players.rotate!
  end

  def play_round
    debugger
    message_new_round

    unless round_over?
      take_turn current_player
    end

    @scores[previous_player] += 1
  end

  def previous_player
    @players.last
  end

  def round_over?

    @working_dictionary.count == 1 && (@working_dictionary.include? @fragment)
  end

  def record(player)
    GHOST[0, @scores[player]]
  end

  def take_turn(player)
    # gets input from current player
    input = ""
    while true
      input = player.guess
      unless valid_play?(input)
        player.alert_invalid_guess
      else
        break
      end
    end
    # updates fragment with player input
    @fragment += input
    # update dictionary
    @working_dictionary.select!{|el| el.start_with? @fragment}

    next_player!
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
    puts "Invalid play. Try again."
  end

  def guess
    puts "Enter a single letter: "
    gets.strip
  end

  def to_s
    @name
  end

end

if __FILE__ == $PROGRAM_NAME
  player_1 = Player.new "Player 1"
  player_2 = Player.new "Player 2"
  game = Game.new(player_1, player_2)
  game.run
end
