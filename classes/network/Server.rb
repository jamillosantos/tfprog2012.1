
module MadBirds
	module Network

		class ClientInterpreter
			def initialize(server, skt)
				puts 'ClientInterpreter::initialize'
				@server = server
				puts 'ClientInterpreter::initialize 2'
				# @client = skt
				puts skt.inspect
				puts 'ClientInterpreter::initialize] Client accepted ' + skt.peeraddr[1].to_s
			end

			def run
				puts 'ClientInterpreter::run'
				while (!@client.eof?)
					puts 'ClientInterpreter::run] Receiving from socket' 
					stream = @socket.recvfrom(2)
				end
				puts 'ClientInterpreter::run] After while'
				if @client.eof?
					puts 'ClientInterpreter::run] Socket eof!' 
					@client.close
				end
				puts 'ClientInterpreter::run] Deleting self'
				@client.delete(self)
			end
		end

		class Server < Chingu::BasicGameObject
			def initialize(options = {})
				@game = options[:game] || $window.current_game_state
				super(options)

				Thread.new do
					server = TCPServer.new('', 9147)
					server.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)

					while !@terminated
						Thread.new(server.accept) do |client|
							ClientInterpreter.new(server, client).run
						end
					end
				end

				@clients = []
				@terminated = false
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
