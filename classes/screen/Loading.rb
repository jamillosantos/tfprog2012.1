
module MadBirds
	module GameStates
		class Loading < Chingu::GameState
			trait :timer
			def initialize(options = {})
				super(options)

				Chingu::GameObject.create(:image => File.join(GFX, 'chrome_mainmenu_bg.png'), :x=>$window.width/2 , :y=>220)
				Chingu::GameObject.create(:image => File.join(GFX, 'loading_image_bird.png'), :x=>$window.width/2 , :y=>220)

				# Begins to load images after 500 milliseconds
				after (500) do
					$imageManager.cache({:menuGeneral=>'config/INGAME_MENU_GENERAL.json'});
					$imageManager.cache({:birds=>'config/INGAME_BIRDS.json'});
					$imageManager.cache({:birdsSoul=>'config/INGAME_BIRDS_SOUL.json'});
					$imageManager.cache({:pigs=>'config/INGAME_PIGS.json'});
					$imageManager.cache({:blocks=>'config/INGAME_BLOCKS_BASIC.json'});
			
					push_game_state(GameExtended)
				end
			end
		end
	end
end
