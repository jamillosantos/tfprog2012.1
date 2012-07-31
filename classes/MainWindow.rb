
require 'gosu'
require 'chingu'

Kernel.r 'screen/MainMenu.rb'

# Janela principal do sistema.
class MainWindow < Chingu::Window
	def initialize
		super

		$imageManager = Geasy::ImageManager.new()

		self.caption = 'Mad Birds'

		switch_game_state(MainMenu)
	end

	def button_down(id)
		if id == Gosu::KbEscape
			close
		else
			super(id)
		end
	end
end
