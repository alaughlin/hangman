class Game
  def initialize(player1, player2)
    # player1 is checker, player2 is guesser
    @player1 = player1
    @player2 = player2
    @turns_left = 6
  end

  def play
    @secret_word_length = @player1.choose_word
    @current_word = ("_" * @secret_word_length).split("")

    until won?
      letter = @player2.guess_letter
      matches = @player1.check_letter(letter)

      if matches.length > 0
        replace_letters(letter, matches)
      else
        @turns_left -= 1
      end
    end
  end

  private
  def won?
    !@current_word.include?("_")
  end

  def replace_letters(letter, matches)
    matches.each do |idx|
      @current_word[idx] = letter
    end
  end
end

class HumanPlayer
  def initialize
    @guessed_letters = []
  end

  def choose_word
    word_length = 0

    until word_length > 0
      print "Enter the secret word's length: "
      word_length = gets.chomp.to_i
    end

    word_length
  end

  def check_letter(letter)
    print "Where does '#{letter}' appear in the secret word? "
    letter_indices = gets.chomp.split(",").map(&:to_i)

    letter_indices
  end

  def guess_letter
    letter = ""
    valid_letter = false

    until valid_letter
      valid_letter = true
      print "Guess a letter: "
      letter = gets.chomp

      if @guessed_letters.include?(letter)
        valid_letter = false
        puts "You already guessed '#{letter}'!"
      elsif letter.length < 1
        valid_letter = false
        puts "You didn't guess a letter!"
      else
        valid_letter = true
      end
    end

    letter
  end
end

class ComputerPlayer
  def initialize
  end

  def choose_word
  end

  def check_letter
  end

  def guess_letter
  end
end

player1 = HumanPlayer.new
player2 = HumanPlayer.new
g = Game.new(player1, player2)
g.play