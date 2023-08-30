# frozen_string_literal: true

require_relative '../lib/round_results'

describe RoundResults do
  let(:card1) { PlayingCard.new('A', 'S') }
  let(:card2) { PlayingCard.new('A', 'H') }
  let(:card3) { PlayingCard.new('4', 'C') }
  let(:card4) { PlayingCard.new('3', 'C') }
  let(:player1) { WarPlayer.new('Muffin') }
  let(:player2) { WarPlayer.new('Potato') }
  let(:round_results) do
    RoundResults.new(cards_in_play: [card1, card2, card3, card4], player1: player1, player2: player2)
  end

  it 'should declare a round win' do
    round_results = RoundResults.new(cards_in_play: [card3, card4], player1: player1, player2: player2)
    expected = 'Muffin wins with 4 of Clubs over 3 of Clubs.'
    expect(round_results.to_s).to eq expected
  end

  it 'should delare a round tie and a round win' do
    expected = "Tie occurred between Ace of Spades and Ace of Hearts.\nMuffin wins with 4 of Clubs over 3 of Clubs."
    expect(round_results.to_s).to eq expected
  end
end
