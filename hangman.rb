class Hangman
  def initialize()
    @all_letters = ('a'..'z').to_a
    @avaliable_letters = @all_letters.dup
    @chosen_word
    @chosen_correct_letters = Array.new()
    @chosen_wrong_letters = Array.new()
    @incorrect_gueses = 0
    @hangman_stages = [" ____\n|    |\n|\n|\n|\n|\n|\n|\n|\n|\n|\n -------"," ____\n|    |\n|    _\n|   | |\n|    -\n|\n|\n|\n|\n|\n|\n -------"," ____\n|    |\n|    _\n|   | |\n|    -\n|    |\n|    |\n|    |\n|\n|\n|\n -------"," ____\n|    |\n|    _\n|   | |\n|    -\n|    |\n|    |\n|    |\n|   |\n|   |\n|\n -------"," ____\n|    |\n|    _\n|   | |\n|    -\n|    |\n|    |\n|    |\n|   | | \n|   | |\n|\n -------"," ____\n|    |\n|    _\n|   | |\n|    -\n|  |-|\n|  | |\n|    |\n|   | |\n|   | |\n|\n -------"," ____\n|    |\n|    _\n|   | |\n|    -\n|  |-|-|\n|  | | |\n|    |\n|   | |\n|   | |\n|\n -------"]
  end
  # Load a random word from the file
  def generate_random_word()
    random_word = String.new()
    until random_word.length > 5 && random_word.length < 12
      random_word.length
      random_word = File.readlines('dict.txt').sample
    end
    @chosen_word = random_word.chomp
  end
  # Check if letter given by player is included in the word
  def check_letter(player_choice)
    if @chosen_word.include?(player_choice)
      @chosen_correct_letters.push(player_choice)
    else
      @incorrect_gueses += 1
      @chosen_wrong_letters.push(player_choice)
    end
  end
  # Display the hangman and letter info
  def display()
    letters_to_keep = [' '].concat(@chosen_correct_letters)
    puts @hangman_stages[@incorrect_gueses]
    puts @chosen_word.chars.to_a.join(' ').gsub(/[^#{letters_to_keep.join('')}]/) { '_' } unless lose?
    puts ''
  end
  # Get player input 
  def get_input()
    player_choice = String.new()
    while !@avaliable_letters.include?(player_choice)
      if !(player_choice == '')
        if !@all_letters.include?(player_choice)
          puts "Incorrect input entered!, choose again."
        else 
          puts "The letter you choose was chosen before, choose again."
        end
      end
      display()
      puts "Incorrect letters: #{@chosen_wrong_letters.join(', ')}" if @chosen_wrong_letters.length > 0
      puts "Avaliable letters: #{@avaliable_letters.join(' ')}"
      print "Choose one of the avaliable letters: "
      player_choice = gets.chomp
      system "clear"
    end
    @avaliable_letters.delete(player_choice)
    player_choice
  end
  def win?
    if @chosen_word.chars.all? {|char| @chosen_correct_letters.include?(char)}
      true
    end
  end
  def lose?
    if @incorrect_gueses >= 6
      true
    end
  end
  def play
    generate_random_word()
    until win? || lose?
      check_letter(get_input())
    end
    display()
    if win?
      puts "You win!"
    end
    if lose?
      puts "You didn't manage to guess the word."
      puts "The word was '#{@chosen_word}'."
    end
  end
end

class GameManager
  def start
    loop = true
    while loop
      system "clear"
      game = Hangman.new()
      game.play()
      puts ''
      player_choice = String.new()
      while !['y','n'].include?(player_choice)
        if !(player_choice == '')
          puts "Incorrect choice entered."
        end
        print "Do you want to play again?(y/n):"
        player_choice = gets.chomp
      end
      if player_choice == 'n'
        loop = false
      end
    end
  end
end
game = GameManager.new()
game.start
