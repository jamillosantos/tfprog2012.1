# -*- coding: utf-8 -*-

require 'geasy'
require 'chingu'
require 'chipmunk'

Kernel.r 'screen/Game.rb'
Kernel.r 'chars/Bird.rb'
Kernel.r 'collisions/Char.rb'
Kernel.r 'collisions/Bullet.rb'
Kernel.r 'maps/Map.rb'

class GameExtended < Game
	traits :viewport

	def initialize(options = {})
		super(options)

		self.viewport.lag = 0
		self.viewport.game_area = [0.0, 0.0, 1000.0, 1000.0]

		@parallaxes = []

		tmp = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => 1)
		tmp.add_layer(:image => GFX+File::SEPARATOR+"BLUE_GRASS_BG_1.png", :damping => 20, :center => 0)
		@parallaxes << tmp

		tmp = Chingu::Parallax.create(:x => 0, :y => 283, :rotation_center => :top_left, :zorder => 10)
		tmp << {:image => GFX+File::SEPARATOR+"BLUE_GRASS_FG_1.png", :y=>0, :damping => 1, :center => 0}
		@parallaxes << tmp

		tmp = Chingu::Parallax.create(:x => 0, :y => tmp.y-30, :rotation_center => :top_left, :zorder => 10)
		tmp << {:image => GFX+File::SEPARATOR+"BLUE_GRASS_FG_2.png", :y=>0, :damping => 1, :center => 0}
		@parallaxes << tmp

		tmp = Chingu::Parallax.create(:x => 0, :y => tmp.y-30, :rotation_center => :top_left, :zorder => 2)
		tmp << {:image => GFX+File::SEPARATOR+"BLUE_GRASS_BG_3.png", :y=>0, :damping => 1, :center => 0}
		@parallaxes << tmp

		@bird2 = Bird.create('redbird')# create(:x=>200, :y=>0, :center_x=>0.5, :center_y=>0.5, :image)

		@bird = Bird.create('redbird')# create(:x=>200, :y=>0, :center_x=>0.5, :center_y=>0.5, :image)
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
		}

		# self.space.add_constraint CP::Constraint::PinJoint.new(@bird.body, @bird2.body, CP::Vec2.new(0,0), CP::Vec2.new(0,0))

		@floor = Map.create(:space=>self.space, :config=>'levels/level1');

	    # self.space.add_collision_handler(:Char, :Floor, MadBirds::Collisions::Char.new)
		bulletCollision = MadBirds::Collisions::Bullet.new
#	    self.space.add_collision_handler(:Bullet, :Floor, bulletCollision)
#	    self.space.add_collision_handler(:Bullet, :Char, bulletCollision)
#	    self.space.add_collision_handler(:Bullet, :Elements, bulletCollision)
#	    self.space.add_collision_handler(:Bullet, :Bullet, bulletCollision)
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
