
module MadBirds
	module UI
		class Ranking < Chingu::GameState
			def initialize(options = {})
				super(options)

				@zorder = 1000000
				@backgroundColor = Gosu::Color.new(0xcc000000)

				@elements = []

				self.input = {
					:released_tab => lambda do
						$window.pop_game_state()
					end
				}
			end

			def update
				$window.game_state_manager.previous_game_state.update
				super
			end

			def draw
				$window.draw_quad(0, 0, @backgroundColor, $window.width, 0, @backgroundColor, $window.width, $window.height, @backgroundColor, 0, $window.height, @backgroundColor, @zorder)
				self.game_objects.draw_relative(0, 0, @zorder+1)
				$window.game_state_manager.previous_game_state.draw
			end
		end
	end
end