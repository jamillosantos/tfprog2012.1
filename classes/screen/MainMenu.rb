# -*- coding: utf-8 -*-

require 'Geasy'
require 'Chingu'

class MainMenu < Chingu::GameState
	def initialize(options = {})
		super(options)
		$imageManager.fromFile('menuGeneral', 'config/INGAME_MENU_GENERAL.json');
	end

	def update
	end

	def draw
		$imageManager.sprites['menuGeneral'].sprites.each do |id, sprite|
			sprite.image.draw(sprite.x, sprite.y, 0);
		end
	end

	def button_down(id)
	end
end
