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
				self.viewport.width = ($window.width/2)-1

				# @server = MadBirds::Network::Server.create(:game=>self)

				# Game rules definition
				@rules = { # Defaults
					:rebirthDelay => 3000,
				}.merge(options[:rules] || {}) # From user

				# Players creation
				@players = [@me = MadBirds::Base::Player1.new({
					:name => 'Jamillo'
				}), MadBirds::Base::Player2.new({
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
					end
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
					# self.viewport.center_around(@me.char) unless @me.char.nil?
		#			self.viewport.x_target = @me.char.x - 320 unless @me.char.nil?
		#			self.viewport.y_target = @me.char.y - 280 unless @me.char.nil?
		
					# Update the traits for the players
					@players.each do |player|
						player.update_trait
					end
					super
				end

				def draw
					w, h = $window.width/2, $window.height
					unless @players[0].char.nil?
						self.viewport.x = @players[0].char.x - w/2
						self.viewport.y = @players[0].char.y - h/2
					end

					$window.clip_to(0, 0, w-1, h) do
						super
					end

					unless @players[1].char.nil?
						self.viewport.x = @players[1].char.x - w/2
						self.viewport.y = @players[1].char.y - h/2
					end
					$window.translate(w+1, 0) do
						$window.clip_to(0, 0, w-1, h) do
							super
						end
					end

					unless @players[0].char.nil?
						self.viewport.x = @players[0].char.x - w/2
						self.viewport.y = @players[0].char.y - h/2
					end
				end
		end
	end
end
