# -*- coding: utf-8 -*-

require 'geasy'
require 'chingu'
require 'chipmunk'

Kernel.r 'screen/Game.rb'
Kernel.r 'chars/Bird.rb'
Kernel.r 'collisions/Char.rb'
Kernel.r 'collisions/Bullet.rb'
Kernel.r 'maps/Map.rb'
Kernel.r 'ui/Ranking.rb'
Kernel.r 'ui/InfoPanel.rb'

class GameExtended < Game
	traits :viewport

	attr_reader :players

	def initialize(options = {})
		super(options)

		self.viewport.lag = 0
		self.viewport.game_area = [0.0, 0.0, 1000.0, 1000.0]

		@players = [MadBirds::Base::Player.new({
			:name => 'Jamillo'
		}), MadBirds::Base::Player.new({
			:name => 'Renno'
		})]

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

		@bird2 = MadBirds::Bird.create(:player=>@players[1], :class=>'redbird')# create(:x=>200, :y=>0, :center_x=>0.5, :center_y=>0.5, :image)

		@bird = MadBirds::Bird.create(:player=>@players[0], :class=>'redbird')# create(:x=>200, :y=>0, :center_x=>0.5, :center_y=>0.5, :image)

		@bird.input = {
			:space => :shoot,
			:x => :startJump,
			:released_x => :jump,
			:left => :turnLeft,
			:right => :turnRight,
			:holding_left => :move,
			:holding_right => :move,
			:up => :startChangeAngle,
			:down => :startChangeAngle,
			:holding_up => :incAngle,
			:holding_down => :decAngle,
			:c => :startReload,
			:holding_c => :checkReload,
			:released_c => :stopReload,
		}

		self.input = {
			:tab => lambda do
				$window.push_game_state(MadBirds::UI::Ranking, :finalize=>false, :setup => false)
			end,
		}

		# self.space.add_constraint CP::Constraint::PinJoint.new(@bird.body, @bird2.body, CP::Vec2.new(0,0), CP::Vec2.new(0,0))

		@map = Map.create(:space=>self.space, :config=>'levels/level1');

		# @infoPanel = MadBirds::UI::InfoPanel.create({})

	    # self.space.add_collision_handler(:Char, :Floor, MadBirds::Collisions::Char.new)
		bulletCollision = MadBirds::Collisions::Bullet.new
	    self.space.add_collision_handler(:Bullet, :Floor, bulletCollision)
	    self.space.add_collision_handler(:Bullet, :Char, bulletCollision)
	    self.space.add_collision_handler(:Bullet, :Elements, bulletCollision)
	    self.space.add_collision_handler(:Bullet, :Bullet, bulletCollision)
	end

	public

		def players
			@players
		end

		def update
			self.viewport.center_around(@bird)
			@parallaxes.each do |parallax|
				parallax.camera_x = self.viewport.x
				parallax.camera_y = self.viewport.y
			end
			super
		end
end
