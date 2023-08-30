# frozen_string_literal: true

require_relative '../lib/card_deck'
require_relative '../lib/playing_card'

describe 'CardDeck' do
  it 'should have a default 52 cards' do
    deck = CardDeck.new
    expect(deck.cards_left).to eq 52
    expect(deck.draw_cards(52).first.suit).to_not be_nil
    expect(deck.shuffled?).to_not be_truthy
  end

  it 'should take cards' do
    cards = [PlayingCard.new('A', 'S')]
    deck = CardDeck.new(cards: cards)
    expect(deck.cards_left).to eq cards.length
  end

  context '#draw_cards' do
    it 'should draw the first top card' do
      deck = CardDeck.new(cards: [PlayingCard.new('A', 'S')])
      card = deck.draw_cards(1).first
      expect(card).to eq PlayingCard.new('A', 'S')
      expect(deck.cards_left).to eq 0
    end

    it 'should draw unique cards' do
      deck = CardDeck.new
      cards = deck.draw_cards(2)
      expect(cards.first).to_not eq cards[1]
    end

    it 'should draw the two top cards' do
      deck = CardDeck.new(cards: [PlayingCard.new('A', 'S'), PlayingCard.new('J', 'S')])
      cards = deck.draw_cards(2)
      expect(cards.first).to eq PlayingCard.new('A', 'S')
      expect(cards.last).to eq PlayingCard.new('J', 'S')
      expect(deck.cards_left).to eq 0
    end
  end

  context '#draw' do
    it 'should draw the first top card' do
      deck = CardDeck.new(cards: [PlayingCard.new('A', 'S')])
      card = deck.draw
      expect(card).to eq PlayingCard.new('A', 'S')
      expect(deck.cards_left).to eq 0
    end
  end

  context '#shuffle' do
    it 'should shuffle the deck' do
      deck1 = CardDeck.new
      deck1.shuffle(1)
      card1 = deck1.draw
      deck2 = CardDeck.new
      deck2.shuffle(2)
      card2 = deck2.draw
      expect(card1).not_to eq card2
    end

    it 'can call shuffle without arguments' do
      expect do
        deck1 = CardDeck.new
        deck1.shuffle
      end.not_to raise_error
    end

    it 'changes shuffled state' do
      deck1 = CardDeck.new
      expect(deck1.shuffled?).to_not be_truthy
      deck1.shuffle
      expect(deck1.shuffled?).to be_truthy
    end
  end

  context '#empty?' do
    it 'should return false when not empty' do
      deck = CardDeck.new
      expect(deck.empty?).to_not be_truthy
    end

    it 'should return true when empty' do
      deck = CardDeck.new(cards: [])
      expect(deck.empty?).to be_truthy
    end
  end
end
