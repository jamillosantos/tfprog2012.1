# -*- coding: utf-8 -*-

module MadBirds
	module GameStates
		class GameExtended < Game
			traits :viewport, :timer
		
			attr_reader :players
		
			def initialize(options = {})
				super(options)
		
				self.viewport.lag = 0
				self.viewport.game_area = [0.0, 0.0, 1000.0, 1000.0]

				@server = MadBirds::Network::Server.create(:game=>self)

				# Game rules definition
				@rules = { # Defaults
					:rebirthDelay => 3000,
				}.merge(options[:rules] || {}) # From user

				# Players creation
				@players = [@me = MadBirds::Base::PlayerMe.new({
					:name => 'Jamillo'
				}), MadBirds::Base::Player.new({
					:name => 'Renno'
				})]

				# First game players join
				after (1000) do
					@players.each do |player|
						player.createChar
					end
				end


				self.input = {
					:tab => lambda do
						$window.push_game_state(MadBirds::UI::Ranking, :finalize=>false, :setup => false)
					end,
				}
		
				@map = MadBirds::Maps::Map.create(:space=>self.space, :config=>'levels/level1');
		
				bulletCollision = MadBirds::Collisions::Bullet.new
			    self.space.add_collision_handler(:Bullet, :Floor, bulletCollision)
			    self.space.add_collision_handler(:Bullet, :Char, bulletCollision)
			    self.space.add_collision_handler(:Bullet, :Elements, bulletCollision)
			    self.space.add_collision_handler(:Bullet, :Bullet, bulletCollision)
			end
		
			public
		
				def rules
					@rules
				end
		
				def players
					@players
				end
		
				def update
					# Center viewport around the @me.char
					self.viewport.center_around(@me.char) unless @me.char.nil?
		#			self.viewport.x_target = @me.char.x - 320 unless @me.char.nil?
		#			self.viewport.y_target = @me.char.y - 280 unless @me.char.nil?
		
					# Update the traits for the players
					@players.each do |player|
						player.update_trait
					end
					super
				end
		end
	end
end
