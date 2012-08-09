
require 'gosu'
require 'chingu'
require 'chipmunk'

Kernel.r 'screen/Game.rb'
Kernel.r 'screen/MainMenu.rb'

# Janela principal do sistema.
class MainWindow < Chingu::Window

	def initialize
		super(640, 480)

		$imageManager = Geasy::ImageManager.new()

		self.caption = 'Mad Birds'

		push_game_state(MainMenu)
	end

	def button_down(id)
		if id == Gosu::KbEscape
			close
		elsif id == Gosu::KbReturn
			push_game_state(MainMenu)
		else
			super(id)
		end
	end
end
