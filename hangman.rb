require 'yaml'
class Hangman
  def initialize()
    @all_letters = ('a'..'z').to_a
    @avaliable_letters = @all_letters.dup
    @chosen_word
    @chosen_correct_letters = Array.new()
    @chosen_wrong_letters = Array.new()
    @incorrect_gueses = 0
    @filename = "saves/save.yaml"
    @hangman_stages = [" ____\n|    |\n|\n|\n|\n|\n|\n|\n|\n|\n|\n -------"," ____\n|    |\n|    _\n|   | |\n|    -\n|\n|\n|\n|\n|\n|\n -------"," ____\n|    |\n|    _\n|   | |\n|    -\n|    |\n|    |\n|    |\n|\n|\n|\n -------"," ____\n|    |\n|    _\n|   | |\n|    -\n|    |\n|    |\n|    |\n|   |\n|   |\n|\n -------"," ____\n|    |\n|    _\n|   | |\n|    -\n|    |\n|    |\n|    |\n|   | | \n|   | |\n|\n -------"," ____\n|    |\n|    _\n|   | |\n|    -\n|  |-|\n|  | |\n|    |\n|   | |\n|   | |\n|\n -------"," ____\n|    |\n|    _\n|   | |\n|    -\n|  |-|-|\n|  | | |\n|    |\n|   | |\n|   | |\n|\n -------"]
  end
  # save to a yaml file
  def save_to_yaml()
    Dir.mkdir('saves') unless Dir.exist?('saves')

    save = YAML.dump ({
      :chosen_word => @chosen_word,
      :chosen_correct_letters => @chosen_correct_letters,
      :chosen_wrong_letters => @chosen_wrong_letters,
      :avaliable_letters => @avaliable_letters,
      :incorrect_gueses => @incorrect_gueses
    })
    File.open(@filename, 'w') do |file|
      file.puts save
    end
  end
  # load from a yaml file
  def load_from_yaml()
    save = File.readlines(@filename).join('')
    data = YAML.load save
    @chosen_word = data[:chosen_word]
    @chosen_correct_letters = data[:chosen_correct_letters]
    @chosen_wrong_letters = data[:chosen_wrong_letters] 
    @avaliable_letters = data[:avaliable_letters] 
    @incorrect_gueses = data[:incorrect_gueses]
  end
  # Load a random word from the dict file
  def generate_random_word()
    random_word = String.new()
    until random_word.length > 5 && random_word.length < 12
      random_word.length
      random_word = File.readlines('dict.txt').sample
    end
    @chosen_word = random_word.chomp
  end
  # get a player response to a message
  def get_player_choice(message,correct_options)
    player_choice = String.new()
    while !correct_options.include?(player_choice)
      if !(player_choice == '')
        puts "Incorrect choice entered."
      end
      print message
      player_choice = gets.chomp
    end
    player_choice
  end
  # Check if letter given by player is included in the chosen word
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
        system "clear"
        if player_choice == "save"
          puts "Game saved!"
          puts ''
          save_to_yaml()
        elsif player_choice == "quit"
          exit
        elsif !@all_letters.include?(player_choice)
          puts "Incorrect input entered!, choose again."
        else
          puts "The letter you choose was chosen before, choose again."
        end
      end
      puts "Type 'save' anytime to save your progress."
      puts "Type 'quit' to leave."
      puts ''
      display()
      puts "Incorrect letters: #{@chosen_wrong_letters.join(', ')}" if @chosen_wrong_letters.length > 0
      puts "Avaliable letters: #{@avaliable_letters.join(' ')}"
      print "Choose one of the avaliable letters: "
      player_choice = gets.chomp
      p player_choice
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
    (load_from_yaml() if get_player_choice("Do you want to load a save?(y/n): ",['y','n']) == 'y') if File.exist?(@filename)
    system "clear"
    until win? || lose?
      check_letter(get_input())
      system "clear"
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
      player_choice = game.get_player_choice("Do you want to play again?(y/n): ",['y','n'])
      if player_choice == 'n'
        loop = false
      end
    end
  end
end

game = GameManager.new()
game.start
