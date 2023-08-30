# frozen_string_literal: true

require_relative 'war_player'
require_relative 'card_deck'

# WarGame is a class based off the rules of https://gamerules.com/rules/war-card-game/
class WarGame
  class NotEnoughPlayers < StandardError; end
  class InvalidBothPlayersOut < StandardError; end

  attr_accessor :player1, :player2, :deck, :cards_in_play, :winner

  def initialize(
    player1: WarPlayer.new('Player 1'),
    player2: WarPlayer.new('Player 2'),
    deck: CardDeck.new
  )
    raise NotEnoughPlayers if player1.nil? || player2.nil?

    @player1 = player1
    @player2 = player2
    @deck = deck || CardDeck.new
    @winner = nil
  end

  def start
    deck.shuffle
    deal
  end

  def deal
    until deck.empty?
      [@player1, @player2].each do |player|
        player.take([deck.draw]) unless deck.empty?
      end
    end
  end

  def play_round(cards_in_play = [])
    player1_card = player1.play
    player2_card = player2.play
    cards_in_play += [player1.play, player1.play].compact

    return finish_round(cards_in_play) unless check_for_game_winner.nil?

    give_cards_to_round_winner(cards_in_play: cards_in_play, player1_card: player1_card, player2_card: player2_card)

    round_results(cards_in_play)
  end

  private

  def give_cards_to_round_winner(cards_in_play:, player1_card:, player2_card:)
    if player1_card.value == player2_card.value
      play_round(cards_in_play)
    elsif player1_card.value > player2_card.value
      player1.take(cards_in_play.shuffle)
    else
      player2.take(cards_in_play.shuffle)
    end
  end

  def round_results(cards_in_play)
    RoundResults.new(cards_in_play: cards_in_play, player1: player1, player2: player2).to_s
  end

  def check_for_game_winner
    return raise InvalidBothPlayersOut if player1.hand.empty? && player2.hand.empty?

    if player1.hand.empty?
      @winner = player2
    elsif player2.hand.empty?
      @winner = player1
    end
  end

  def finish_round(cards_in_play)
    winner.take(cards_in_play)
    round_results(cards_in_play) + "\n#{winner.name} wins!"
  end
end
