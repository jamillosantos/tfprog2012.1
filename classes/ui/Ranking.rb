
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

				@game = $window.game_state_manager.current_game_state
			end

			def update
				super
				@game.update
			end

			def draw
				$window.draw_quad(0, 0, @backgroundColor, $window.width, 0, @backgroundColor, $window.width, $window.height, @backgroundColor, 0, $window.height, @backgroundColor, @zorder)
				self.game_objects.draw_relative(0, 0, @zorder+1)
				@game.draw
			end
		end
	end
end