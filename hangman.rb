class Game
  attr_reader :secret_word_length

  def initialize(player1, player2)
    # player1 is checker, player2 is guesser
    @player1 = player1
    @player2 = player2
    @chances_left = 6
  end

  def play
    @secret_word_length = @player1.choose_word
    @current_word = ("_" * @secret_word_length).split("")

    print "\n"
    until won? || @chances_left < 1
      letter = @player2.guess_letter(@current_word, @chances_left)
      matches = @player1.check_letter(letter)
      check_for_matches(letter, matches)
    end

    won? ? winning_game : losing_game
  end

  private
  def won?
    !@current_word.include?("_")
  end

  def check_for_matches(letter, matches)
    if matches.length > 0
      replace_letters(letter, matches)
      print "\n"
    else
      puts "\nNo '#{letter}' found!\n\n"
      @chances_left -= 1
    end
  end

  def replace_letters(letter, matches)
    matches.each do |idx|
      @current_word[idx] = letter
    end
  end

  def winning_game
    puts "Guesser won!"
  end

  def losing_game
    puts "Out of turns, guesser lost!"
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
    letter_indices = gets.chomp.split(",").map(&:to_i).map { |n| n - 1 }

    letter_indices
  end

  def guess_letter(current_word, chances_left)
    letter = ""
    valid_letter = false

    until valid_letter
      valid_letter = true
      prompt_text(current_word, chances_left)
      letter = gets.chomp

      if @guessed_letters.include?(letter)
        valid_letter = false
        puts "You already guessed '#{letter}'!\n\n"
      elsif letter.length < 1
        valid_letter = false
        puts "You didn't guess a letter!"
      else
        @guessed_letters << letter
        valid_letter = true
      end
    end

    letter
  end

  def prompt_text(current_word, chances_left)
    puts "Turns_left: #{chances_left}"
    puts "Current word: #{current_word.join(" ")}"
    puts "Guessed letters: #{@guessed_letters.sort.join(" ")}\n\n"
    print "Guess a letter: "
  end
end

class ComputerPlayer
  def initialize
    @dictionary = File.readlines("dictionary.txt").map(&:chomp)
    @shorten_choices_by_length = false
    @guessed_letters = []
  end

  def choose_word
    @secret_word = @dictionary.sample
    
    @secret_word.length
  end

  def check_letter(letter)
    res = []

    (@secret_word.length).times do |idx|
      res << idx if @secret_word[idx] == letter
    end

    res
  end

  def guess_letter(current_word, chances_left)
    prompt_text(current_word, chances_left)
    first_minimize(current_word) if !@shorten_choices_by_length

    letter = get_most_popular_letter

    letter
  end

  def first_minimize(current_word)
    @dictionary = @dictionary.select { |word| word.length == current_word.length }
    @shorten_choices_by_length = true
  end

  def get_most_popular_letter
    letter_counts = Hash.new(0)

    @dictionary.each do |word|
      word.each_char do |letter|
        letter_counts[letter] += 1 unless @guessed_letters.include?(letter)
      end
    end

    popular_letter = letter_counts.sort_by { |key, val| val }.reverse[0][0]
    @guessed_letters << popular_letter

    popular_letter
  end

  def prompt_text(current_word, chances_left)
    puts "Turns_left: #{chances_left}"
    puts "Current word: #{current_word.join(" ")}"
    puts "Guessed letters: #{@guessed_letters.sort.join(" ")}\n\n"
  end
end

player1 = HumanPlayer.new
player2 = ComputerPlayer.new
g = Game.new(player1, player2)
g.play
