# frozen_string_literal: true

require_relative 'serialize'
require 'yaml'
# This class controls game flow
class Game
  attr_accessor :guessed_letters, :correct_letters, :incorrect_letters, :available_guesses

  include Serialize
  def initialize
    @guessed_letters = []
    @incorrect_letters = []
    @correct_letters = []
    @available_guesses = 8
    game_setup
  end

  def game_setup
    puts 'Would you like to: 1) Start new game'
    puts '                   2) Load previous game'
    game_choice = gets.chomp
    start if game_choice == '1'
    load_game if game_choice == '2'
  end

  def start
    @word = create_secret_word
    @split_word = @word.split('')
    display_empty_spaces
    play
    end_game
  end

  def display_empty_spaces
    @split_word.each { @correct_letters << '_' }
  end

  def play
    until game_over?
      display_correct_letters
      display_incorrect_letters
      solicit_guess
      evaluate_guess
    end
  end

  def display_correct_letters
    puts @correct_letters.join.to_s
  end

  def display_incorrect_letters
    puts "You have incorrectly guessed letter(s)
    ===============
    #{@incorrect_letters.join(',')}
    ===============
    and have #{@available_guesses} number of guesses left."
  end

  def solicit_guess
    puts 'Enter a letter or type save to play later:'
    input = gets.chomp.downcase
    if input == 'save'
      save_game
      exit
    elsif input.match?(/^[a-z]$/) &&
          !@guessed_letters.include?(input)
      @guess = input
    else
      puts 'Invalid input.'
      solicit_guess
    end
  end

  def evaluate_guess
    if @word.include?(@guess)
      add_correct_letter
    else
      @incorrect_letters << @guess
      @available_guesses -= 1
    end
    @guessed_letters << @guess
  end

  def add_correct_letter
    @split_word.each_with_index do |value, index|
      @correct_letters[index] = value if value == @guess
    end
  end

  def game_over?
    if @split_word.eql?(@correct_letters)
      display_correct_letters
      puts 'Game over, you won!'
      true
    elsif @available_guesses.zero?
      puts 'Game over, you lost!'
      display_secret_word
      true
    end
  end

  def end_game
    puts 'Would you like to start a new game?'
    puts 'Y/N'
    case gets.chomp.upcase
    when 'Y'
      Game.new
    when 'N'
      puts 'Thanks for playing!'
      exit
    else
      end_game
    end
  end

  def display_secret_word
    puts "The secret word you were trying to guess is #{@word}."
  end

  def create_secret_word
    dictionary = File.open('5desk.txt', 'r')
    available_words = []
    dictionary.each do |line|
      line.strip!.downcase
      if line.length <= 12 &&
         line.length >= 5
        available_words << line
      end
    end
    dictionary.close
    available_words.sample
  end
end
