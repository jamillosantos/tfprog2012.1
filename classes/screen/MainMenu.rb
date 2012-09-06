
require 'chingu'

Kernel.r 'screen/GameExtended'

class MainMenuBackground < Chingu::GameObject
	traits :sprite


end


class MainMenu < Chingu::GameState

	def initialize(options = {})
		
		super(options)
		
		a = MainMenuBackground.create(:image => GFX+File::SEPARATOR+"chrome_mainmenu_bg.png",:x=>$window.width/2,:y=>190) ;
		b = MainMenuBackground.create(:image => GFX+File::SEPARATOR+"letras_m.png",:x=>$window.width/2,:y=>220) ;
		c = MainMenuBackground.create(:image => GFX+File::SEPARATOR+"loading_image_bird.png",:x=>$window.width/2,:y=>220) ;		
		self.input = {	
			:a => :launchPlay
		}
	end

	def launchPlay
		puts 'GameExtended'
		push_game_state GameExtended
	end
end

	
	
	
