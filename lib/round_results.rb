# frozen_string_literal: true

require_relative '../lib/war_player'
require_relative '../lib/playing_card'
require_relative '../lib/card_deck'

# converts cards to output string
class RoundResults
  attr_accessor :rounds, :player1, :player2

  def initialize(cards_in_play:, player1:, player2:)
    number_of_players = 2
    @rounds = cards_in_play.each_slice(number_of_players).reject { |round| round.length == 1 }.to_a
    @player1 = player1
    @player2 = player2
  end

  def to_s
    rounds.map do |round|
      player1_card, player2_card = round
      if player1_card.value == player2_card.value
        "Tie occurred between #{player1_card} and #{player2_card}."
      elsif player1_card.value > player2_card.value
        "#{player1.name} wins with #{player1_card} over #{player2_card}."
      elsif player1_card.value < player2_card.value
        "#{player2.name} wins with #{player2_card} over #{player1_card}."
      end
    end.join("\n")
  end
end
