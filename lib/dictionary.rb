# frozen_string_literal: true

class Dictionary
  def read_dictionary
    @f = File.open('dictionaries/google-10000-english-no-swears.txt')

    @dictionary = []
    i = 0

    while (line = @f.gets)
      line = line.chomp.upcase
      if line.length >= 5 && line.length <= 12
        @dictionary[i] = line
        i += 1
      end
    end
    @f.close
  end

  def read_word
    @word = @dictionary.sample
  end
end
