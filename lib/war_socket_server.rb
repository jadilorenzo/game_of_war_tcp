# frozen_string_literal: true

require 'socket'

# WarSocketServer
class WarSocketServer
  def port_number
    3336
  end

  def games
    []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(_player_name = 'Random Player')
    @server.accept_nonblock
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    Rails.logger.debug 'No client to accept'
  end

  def create_game_if_possible; end

  def stop
    @server&.close
  end
end
