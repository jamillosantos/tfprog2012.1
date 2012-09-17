# -*- coding: utf-8 -*-

class GameExtended < Game
	traits :viewport, :timer

	attr_reader :players

	def initialize(options = {})
		super(options)

		self.viewport.lag = 0
		self.viewport.game_area = [0.0, 0.0, 1000.0, 1000.0]

		@rules = {
			:rebirthDelay => 3000,
		}.merge(options[:rules] || {})

		@players = [@me = MadBirds::Base::PlayerMe.new({
			:name => 'Jamillo'
		}), MadBirds::Base::Player.new({
			:name => 'Renno'
		})]

		after (2000) do
			@players.each do |player|
				player.createChar
			end
		end

		@parallaxes = []

		tmp = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => 1)
		tmp.add_layer(:image => GFX+File::SEPARATOR+"BLUE_GRASS_BG_1.png", :damping => 200, :center => 0)
		@parallaxes << tmp

		tmp = Chingu::Parallax.create(:x => 0, :y => 813, :rotation_center => :top_left, :zorder => 10)
		tmp << {:image => GFX+File::SEPARATOR+"BLUE_GRASS_FG_1.png", :y=>0, :damping => 1, :center => 0}
		@parallaxes << tmp

		tmp = Chingu::Parallax.create(:x => 0, :y => tmp.y-30, :rotation_center => :top_left, :zorder => 10)
		tmp << {:image => GFX+File::SEPARATOR+"BLUE_GRASS_FG_2.png", :y=>0, :damping => 1, :center => 0}
		@parallaxes << tmp

		tmp = Chingu::Parallax.create(:x => 0, :y => tmp.y-30, :rotation_center => :top_left, :zorder => 2)
		tmp << {:image => GFX+File::SEPARATOR+"BLUE_GRASS_BG_3.png", :y=>0, :damping => 1, :center => 0}
		@parallaxes << tmp

		# @bird2 = MadBirds::Bird.create(:player=>@players[1], :class=>'redbird')# create(:x=>200, :y=>0, :center_x=>0.5, :center_y=>0.5, :image)

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

			# Update parallaxes
			@parallaxes.each do |parallax|
				parallax.camera_x = self.viewport.x
				parallax.camera_y = self.viewport.y
			end
			super
		end
end
