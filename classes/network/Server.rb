
module MadBirds
	module Network

		class ClientInterpreter
			def initialize(server, socket)
				@server = server
				@socket = socket
				puts 'ClientInterpreter::initialize] Client accepted ' + socket.peeraddr[1]
			end

			def run
				puts 'ClientInterpreter::run'
				while (!@socket.eof?)
					puts 'ClientInterpreter::run] Receiving from socket' 
					stream = @socket.recvfrom(2)
				end
				puts 'ClientInterpreter::run] After while'
				if @socket.eof?
					puts 'ClientInterpreter::run] Socket eof!' 
					@socket.close
				end
				puts 'ClientInterpreter::run] Deleting self'
				@server.delete(self)
			end
		end

		class Server < Chingu::BasicGameObject
			def initialize(options = {})
				puts 'Server::initialize'
				@game = options[:game] || $window.current_game_state
				super(options)
				@server = TCPServer.new('', 9147)
				@server.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)
				puts 'Server::initialize'

				@clients = []
				@terminated = false
				Thread.start do
					puts 'Server::initialize::Thread::start'
					while !@terminated do
						puts 'Server::initialize::Thread::start] Loop'
						client = @server.accept
						@clients << Thread.new { ClientInterpreter.new(@server, client).run }
						puts 'Server::initialize::Thread::start] After accept'
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
