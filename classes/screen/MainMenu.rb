# -*- coding: utf-8 -*-

require 'geasy'
require 'chingu'

Kernel.r 'screen/Game.rb'
Kernel.r 'chars/Bird.rb'

class MainMenu < Game
	def initialize(options = {})
		super(options)

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

		Bird.create(:image_prefix => 'BIRD_RED', :x=>200, :y=>200, :zorder=>5).input = {
			:up => :jump,
			:holding_left => :moveLeft,
			:holding_right => :moveRight,
		}

		@floor = {
			:body=>(tmpBody = CP::Body.new(Geasy::INFINITY, Geasy::INFINITY)),
		    :shape=>CP::Shape::Segment.new(tmpBody, CP::Vec2.new(0,283), CP::Vec2.new(1000, 283), 1)
		}

		@floor[:body].p = CP::Vec2.new(0, 0)
	    @floor[:body].v = CP::Vec2.new(0, 0)

		@floor[:shape].e = 0.3
		@floor[:shape].u = 0.3

	    self.space().add_static_shape(@floor[:shape])
	end

	def update
		@parallaxes.each do |parallax|
			parallax.camera_x += 1
		end
		super
	end
end
