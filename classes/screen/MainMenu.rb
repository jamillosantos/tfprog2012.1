
require 'chingu'

Kernel.r 'screen/GameExtended'

class MainMenu < Chingu::GameState
	def initialize(options = {})
		super(options)

		a = Chingu::GameObject.create(:image => GFX+File::SEPARATOR+"BLUE_GRASS_FG_2.png")

		self.input = {
			:a => :launchPlay
		}
	end

	def launchPlay
		puts 'GameExtended'
		push_game_state GameExtended
	end
end