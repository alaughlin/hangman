class Game
  def initialize(player1, player2)
    # player1 is checker, player2 is guesser
    @player1 = player1
    @player2 = player2
  end

  def play
  end

  def won?
  end
end

class HumanPlayer
  def initialize
  end

  def choose_word
  end

  def check_letter
  end

  def guess_letter
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