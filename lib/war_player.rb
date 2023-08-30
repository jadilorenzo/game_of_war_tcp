# frozen_string_literal: true

class WarPlayer
  attr_accessor :name, :hand

  def initialize(name, hand: [])
    @name = name
    @hand = hand
  end

  def take(cards_to_take)
    cards_to_take.each { |card| @hand.push card }
  end

  def play
    @hand.shift
  end
end
