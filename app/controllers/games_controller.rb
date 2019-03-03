require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    @pickers = ('a'..'z').to_a
    10.times do
      @letters << @pickers.sample
    end
    # session[:score] = 0
  end

  def score
    @word = params[:suggestion]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_serialized = open(url).read
    resp = JSON.parse(word_serialized)

    @validcheck = resp['found']
    # delivers boolean, already able to check if @word is a valid dictionary word

    my_word = @word.downcase.split('').sort
    # word that needs to be checked, ["e", "n", "w"]

    @lettercheck = params[:letters]
    @lettercheck = @lettercheck.split.sort
    # ["e", "l", "m", "o", "r", "r", "s", "t", "u", "z"] - the random letters, sorted, in alpha order, array of strings
    @check = true
    my_word.each do |letter|
      @lettercheck.include?(letter) ? @lettercheck = @lettercheck - [letter] : @check = false
    end
    session[:score] += my_word.length if @check
    # if the characters match out, my_word is empty array, @check is true, else
    # @check is false
    # raise
  end
end
