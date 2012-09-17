
module MadBirds
	module Network

		class ClientInterpreter < Thread
			def initialize(server, socket)
				@server = server
				@socket = socket
			end

			def run
				while (!@socket.eof?)
					
				end
				if @socket.eof?
					@socket.close
				else
					stream = @socket.recvfrom(2)
				end
				@server.delete(self)
			end
		end

		class Server < Chingu::GameObject
			def initialize(options = {})
				@game = options[:game] || $window.current_game_state
				super(options)
				@server = TCPSocket.new(9147)
				@server.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)
				@clients = []
				@terminated = false
				Thread.new do
					while !self.terminated do
						@clients << NetworkPlayer.new(self, @server.accept)
					end
				end
			end

			def delete(client)
				@clients.delete(client)
			end

			def terminate
				@temrinated = true
			end
		end
	end
end
