# frozen_string_literal: true

# This module saves and loads games
module Serialize
  def save_game
    filename = 'saved_game.yaml'
    File.open(filename.to_s, 'w') { |file| file.write to_yaml }
    puts 'Your game has been saved.'
  end

  def to_yaml
    YAML.dump(
      'word' => @word,
      'split_word' => @split_word,
      'correct_letters' => @correct_letters,
      'incorrect_letters' => @incorrect_letters,
      'guessed_letters' => @guessed_letters,
      'available_guesses' => @available_guesses
    )
  end

  def from_yaml
    saved = YAML.safe_load(File.read('saved_game.yaml'))
    @word = saved['word']
    @split_word = saved['split_word']
    @correct_letters = saved['correct_letters']
    @incorrect_letters = saved['incorrect_letters']
    @guessed_letters = saved['guessed_letters']
    @available_guesses = saved['available_guesses']
  end

  def load_game
    if File.exist?('saved_game.yaml')
      from_yaml
      play
      File.delete('saved_game.yaml')
      end_game
    else
      puts 'You have no saved games.'
      exit
    end
  end
end
