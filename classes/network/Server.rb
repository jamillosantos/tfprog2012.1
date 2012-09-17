
require 'socket'

module MadBirds
	module Network
		class Server < Chingu::GameObject
			def initialize(options = {})
				super(options)
				@socket = ''
			end
		end
	end
end
