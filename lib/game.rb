# frozen_string_literal: true

require_relative 'guess'
require_relative 'word'

class Game
  def initialize
    @win = false
    @counter = 5
    @incorrect = []
    @guess = ''
    @target = Word.new
    @target = @target.pick_word
    @show = @target.map { |_l| '_' }
  end

  def play_round
    puts 'Find this word:'
    puts @show.join
    puts "Lives: #{@counter}"
    @guess = gets.chomp.upcase
    check_guess
    puts "incorrect guesses #{@incorrect}" if @incorrect.length.positive?

    return if @win

    check_loss
  end

  def check_guess
    if @incorrect.include?(@guess)
      puts("You already guessed #{@guess}")

    elsif @guess.length == 1
      if @target.include?(@guess)
        @target.each_with_index do |_letter, i|
          @show[i] = @guess if @guess == @target[i]
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

    if @guess == @target.join || @show.join.include?('_') == false
      puts "You won!, congratulations! the word was '#{@target.join}'"
      @win = true
    end

    @guess = ''
  end

  private

  def reset_game; end

  def check_loss
    if @counter.positive?
      play_round
    else
      puts "The word was #{@target.join}, try again!"
      reset_game
    end
  end
end
