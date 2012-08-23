
require 'chingu'

Kernel.r 'screen/GameExtended'

class MainMenu < Chingu::GameState
	def initialize(options = {})
		super(options)

		self.input = {
			:a => :launchPlay
		}
	end

	def launchPlay
		puts 'GameExtended'
		push_game_state GameExtended
	end
end