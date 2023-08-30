# frozen_string_literal: true

require_relative 'war_game'

game = WarGame.new
game.start
Rails.logger.debug game.play_round until game.winner
Rails.logger.debug { "Winner: #{game.winner.name}" }
