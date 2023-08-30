# frozen_string_literal: true

require_relative '../lib/war_game'
require_relative '../lib/playing_card'
require_relative '../lib/war_player'

describe 'WarGame' do
  let(:player1) { WarPlayer.new('Muffin') }
  let(:player2) { WarPlayer.new('Potato') }
  let(:game) { WarGame.new(player1: player1, player2: player2) }

  context '#initialize' do
    it 'has players, card deck, and cards in play' do
      expect(player1.name).to eq('Muffin')
      expect(player2.name).to eq('Potato')
      expect(game.deck).to_not be_nil
      expect(game.winner).to be_nil
    end

    it 'throws error if not enough players' do
      expect do
        WarGame.new(player1: [WarPlayer.new('Bobby Big Boy')], player2: nil)
      end.to raise_error(WarGame::NotEnoughPlayers)
      expect { WarGame.new(player1: nil, player2: nil) }.to raise_error(WarGame::NotEnoughPlayers)
    end

    it 'takes a deck' do
      card_deck = CardDeck.new
      game = WarGame.new(deck: card_deck)
      expect(game.deck).to eq card_deck
      expect(game.deck.shuffled?).to be false
    end
  end

  context '#start' do
    it 'shuffles the deck and deals the cards' do
      game.start

      # Assert the deck is shuffled
      expect(game.deck.shuffled?).to be true
      expect(player1.hand.length).to eq(CardDeck::DECK_SIZE / 2)
      expect(player2.hand.length).to eq(CardDeck::DECK_SIZE / 2)
    end
  end

  context '#deal' do
    it 'should deal all the cards' do
      game.deal
      expect(game.deck.empty?).to be_truthy
      expect(player1.hand.length).to eq CardDeck::DECK_SIZE / 2
      expect(player2.hand.length).to eq CardDeck::DECK_SIZE / 2
    end
  end

  context '#play_round' do
    it 'should result in players having different numbers of cards' do
      game.deal
      game.play_round
      expect(player1.hand.length).to_not eq player2.hand.length
    end

    it 'should give the appropriate players cards' do
      player1 = WarPlayer.new('Muffin', hand: [PlayingCard.new('A', 'S'), PlayingCard.new('5', 'D')])
      player2 = WarPlayer.new('Potato', hand: [PlayingCard.new('Q', 'S')])
      game = WarGame.new(player1: player1, player2: player2)
      game.play_round
      expect(player1.hand.length).to eq 3
      expect(player2.hand.length).to eq 0
    end

    it 'continues after ties to give all cards to correct player' do
      player1 = WarPlayer.new('Muffin',
                              hand: [PlayingCard.new('A', 'H'), PlayingCard.new('Q', 'S'), PlayingCard.new('J', 'C'),
                                     PlayingCard.new('K', 'D')])
      player2 = WarPlayer.new('Potato',
                              hand: [PlayingCard.new('A', 'S'), PlayingCard.new('Q', 'D'), PlayingCard.new('10', 'C')])
      game = WarGame.new(player1: player1, player2: player2)
      game.play_round
      expect(player1.hand.length).to eq 7
      expect(player2.hand.length).to eq 0
    end

    fit 'returns appropriate messages when there is a tie' do
      player1 = WarPlayer.new('Muffin', hand: [
        PlayingCard.new('A', 'S'),
                                PlayingCard.new('A', 'C'),
                                PlayingCard.new('J', 'C')
      ])
      player2 = WarPlayer.new('Potato', hand: [PlayingCard.new('A', 'H'), PlayingCard.new('Q', 'S')])
      game = WarGame.new(player1: player1, player2: player2)
      round_results = game.play_round
      expect(game.winner).to eq player1
      expect(round_results).to eq "Tie occurred between Ace of Spades and Ace of Hearts.\nMuffin wins with Ace of Clubs over Queen of Spades.\nMuffin wins!"
      expect(round_results).to include 'Tie'
      expect(round_results).to_not include 'Potato'
      expect(round_results).to include 'Muffin'
    end

    it 'raises an InvalidBothPlayersOut error when both players have empty hands' do
      player1 = WarPlayer.new('Muffin', hand: [])
      player2 = WarPlayer.new('Potato', hand: [])
      game = WarGame.new(player1: player1, player2: player2)
      expect { game.play_round }.to raise_error(WarGame::InvalidBothPlayersOut)
    end

    it 'should determine winner' do
      player1 = WarPlayer.new('Muffin', hand: [])
      player2 = WarPlayer.new('Potato', hand: [PlayingCard.new('A', 'S'), PlayingCard.new('Q', 'S')])
      game = WarGame.new(player1: player1, player2: player2)

      round_results = game.play_round
      expect(round_results).to include 'Potato wins!'
      expect(game.winner).to eq player2
      expect(player1.hand.length).to eq 0
      expect(player2.hand.length).to eq 2
    end
  end

  it 'can play through the whole game' do
    game = WarGame.new
    game.start
    game.play_round until game.winner

    expect(game.winner).to_not be_nil
  end
end
