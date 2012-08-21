# -*- coding: utf-8 -*-

require 'geasy'
require 'chingu'

Kernel.r 'screen/Game.rb'
Kernel.r 'chars/Bird.rb'
Kernel.r 'collisions/Char.rb'
Kernel.r 'maps/Map.rb'

class MainMenu < Game
	traits :timer, :viewport

	def initialize(options = {})
		super(options)

		self.viewport.lag = 0
		self.viewport.game_area = [0, 0, 1000, 1000]

		@parallaxes = []

		tmp = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => 1)
		tmp.add_layer(:image => GFX+File::SEPARATOR+"BLUE_GRASS_BG_1.png", :damping => 50)
		@parallaxes << tmp

		tmp = Chingu::Parallax.create(:x => 0, :y => 283, :rotation_center => :top_left, :zorder => 1)
		tmp << {:image => GFX+File::SEPARATOR+"BLUE_GRASS_FG_1.png", :y=>100, :damping => 1}
		@parallaxes << tmp

		tmp = Chingu::Parallax.create(:x => 0, :y => tmp.y-30, :rotation_center => :top_left, :zorder => 1)
		tmp << {:image => GFX+File::SEPARATOR+"BLUE_GRASS_FG_2.png", :y=>-100, :damping => 1}
		@parallaxes << tmp

		$imageManager.cache({'menuGeneral'=>'config/INGAME_MENU_GENERAL.json'});
		$imageManager.cache({'birds'=>'config/INGAME_BIRDS.json'});

		@bird = Bird.create('redbird')# create(:x=>200, :y=>0, :center_x=>0.5, :center_y=>0.5, :image)
		@bird.input = {
			:x => :startJump,
			:released_x => :jump,
			:holding_left => :moveLeft,
			:holding_right => :moveRight,
			:up => :startChangeAngle,
			:down => :startChangeAngle,
			:holding_up => :incAngle,
			:holding_down => :decAngle,
		}

		@floor = Map.create({});

		#
		#@floor = {
		#	:body=>(tmpBody = CP::Body.new(Geasy::INFINITY, Geasy::INFINITY)),
		#    :shape=>CP::Shape::Segment.new(tmpBody, CP::Vec2.new(0,283), CP::Vec2.new(1000, 283), 1)
		#}

		#@floor[:body].p = CP::Vec2.new(0, 0)
	    #@floor[:body].v = CP::Vec2.new(0, 0)

		#@floor[:shape].e = 0.3
		#@floor[:shape].u = 0.3
		#@floor[:shape].collision_type = :Floor

	    self.space.add_static_shape(@floor.shapes.first)

		#self.space.add_collision_func(:Char, :Floor) do |char, floor|
		#	puts "Colidiu essa BUDEGA!!"
		#	true
	    #end
	    self.space.add_collision_handler(:Char, :Floor, MadBirds::Collisions::Char.new)
	end

	def update
		#@parallaxes.each do |parallax|
		#	parallax.camera_x += 1
		#end
		self.viewport.center_around(@bird)
		super
	end
end
