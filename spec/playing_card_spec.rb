# frozen_string_literal: true

require_relative '../lib/playing_card'

describe 'PlayingCard' do
  it 'has rank and suit' do
    card = PlayingCard.new('A', 'S')
    expect(card.rank).to eq 'A'
    expect(card.suit).to eq 'S'
  end

  it 'only takes a valid rank and suit' do
    expect do
      PlayingCard.new('34',
                      'Geese')
    end.to raise_error(PlayingCard::InvalidRankOrSuitError, 'Invalid rank or suit: 34 and Geese')
    expect do
      PlayingCard.new('3',
                      'Geese')
    end.to raise_error(PlayingCard::InvalidRankOrSuitError, 'Invalid rank or suit: 3 and Geese')
    expect do
      PlayingCard.new('34', 'C')
    end.to raise_error(PlayingCard::InvalidRankOrSuitError, 'Invalid rank or suit: 34 and C')
  end

  context '#==' do
    it 'returns true for equal cards' do
      card1 = PlayingCard.new('A', 'S')
      card2 = PlayingCard.new('A', 'S')
      expect(card1).to eq card2
    end

    it 'returns false for unequal cards' do
      card1 = PlayingCard.new('A', 'S')
      card2 = PlayingCard.new('A', 'C')
      expect(card1).to_not eq card2
      card3 = PlayingCard.new('Q', 'S')
      card4 = PlayingCard.new('A', 'S')
      expect(card3).to_not eq card4
    end

    it 'returns false for non-card' do
      card1 = PlayingCard.new('A', 'S')
      expect(card1).to_not eq 'A S'
    end
  end

  context '#value' do
    it 'returns correct value' do
      card1 = PlayingCard.new('A', 'S')
      card2 = PlayingCard.new('2', 'H')
      expect(card1.value).to eq 14
      expect(card2.value).to eq 2
    end
  end

  context '#to_s' do
    it 'returns a string representation of the playing card' do
      card = PlayingCard.new('A', 'S')
      expect(card.to_s).to eq 'Ace of Spades'

      card = PlayingCard.new('2', 'H')
      expect(card.to_s).to eq '2 of Hearts'

      card = PlayingCard.new('Q', 'D')
      expect(card.to_s).to eq 'Queen of Diamonds'

      card = PlayingCard.new('K', 'C')
      expect(card.to_s).to eq 'King of Clubs'
    end
  end
end
