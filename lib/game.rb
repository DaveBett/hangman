# frozen_string_literal: true

require_relative 'word'

class Game
  def initialize
    @win = false
    @counter = 5
    @incorrect = []
    @guess = ''
    @target = Word.new
    @target = @target.pick_word
    @progress = @target.map { |_l| '_' }
  end

  def play_round
    puts 'Find this word:'
    puts @progress.join
    puts "Lives: #{@counter}"
    @guess = gets.chomp.upcase
    check_guess
    puts "incorrect guesses #{@incorrect}" if @incorrect.length.positive?

    return if @win

    check_loss
  end

  def check_guess
    if @guess.downcase == 'save'
      puts 'Do you wish to save the game? (y/n)'
      response = gets.chomp.downcase
      if response == 'y'
        save_game
        puts 'Game saved!'
      end

    else

      if @incorrect.include?(@guess)
        puts("You already guessed #{@guess}")

      elsif @guess.length == 1
        if @target.include?(@guess)
          @target.each_with_index do |_letter, i|
            @progress[i] = @guess if @guess == @target[i]
          end
        else
          puts "The letter #{@guess} is not present"
          @counter -= 1
          @incorrect.push(@guess)
        end
      else
        puts "That's not the word, sorry"
        @counter -= 1
        @incorrect.push(@guess)
      end

      if @guess == @target.join || @progress.join.include?('_') == false
        puts "You won!, congratulations! the word was '#{@target.join}'"
        @win = true
      end

      @guess = ''
    end
  end

  def save_game
    save_data = { word: @target, progress: @progress, counter: @counter }
    data_json = save_data.to_json
    save_file = File.open('save_data.json', 'w')
    save_file.puts data_json
    save_file.close
  end

  def load_game
    load_file = File.open('save_data.json', 'r')
    load_data = load_file.gets
    @load_info = JSON.parse(load_data)
    load_file.close
    @target = @load_info['word']
    @progress = @load_info['progress']
    @counter = @load_info['counter']
  end

  def ask_load
    if File.file?('save_data.json')
      puts 'Would you like to load from a save file? [y/n]'
      response = gets.chomp.downcase
      if response == 'y'
        load_game
        puts 'Game loaded!'
      elsif response == 'n'
        puts 'Starting new game...'
      else
        puts 'Invalid response. Starting new game..'
      end
    end
    play_round
  end

  def check_loss
    if @counter.positive?
      play_round
    else
      puts "The word was #{@target.join}, try again!"
      reset_game
    end
  end
end
