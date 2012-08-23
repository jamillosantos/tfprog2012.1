
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

		self.input = {
			:escape => :exit
		}
	end

	def button_down(id)
		if id == Gosu::KbReturn
			push_game_state(MainMenu)
		elsif id == Gosu::KbF12
			$window.screenshot('teste.png')
		elsif id == Gosu::KbF3
			puts self.factor
			self.factor=10
		elsif id == Gosu::KbF1
		self.factor=(2)
			@rotation ||= 0
			@rotation += 1
		elsif id == Gosu::KbF2
			@rotation ||= 0
			@rotation -= 1
		else
			super(id)
		end
	end

	def update
		super
	end

	def draw
		super
	end
end
