# frozen_string_literal: true

require_relative 'dictionary'

class Word < Array
  def pick_word
    @dictionary.read_dictionary
    @word = @dictionary.read_word
    @word = @word.split('')
  end
end
