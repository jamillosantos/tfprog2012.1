
module MadBirds
	module Maps
		class BaseMap < Geasy::CPObject
		
			attr_accessor :bgColor
		
			def initialize(options)
				self.bgColor = options[:bgColor] unless options[:bgColor].nil?
				super(options.merge({:static=>true}))
			end
		
			protected
				def _setupElements
					if ((els = @setupOptions[:elements]).is_a? String)
						els = $config[@setupOptions[:elements]]
					end
					Elements::BaseElement.create(:space=>self.space,:image=>$imageManager.ids(:WOOD_CIRCLE_4X4).image, :collisionType=>:Elements, :x=>150, :y=>10, :body=>{ :weight=>4, :moment=>10000}, :shapes=>{ :type => :circle, :radius=>35, :offset=>CP::Vec2.new(0, 0), :friction=>1 })
					Elements::BaseElement.create(:space=>self.space,:image=>$imageManager.ids(:WOOD_BLOCK_2X2).image, :collisionType=>:Elements, :angle=>320*rand(), :x=>350, :y=>10, :body=>{ :weight=>2, :moment=>10000}, :shapes=>{ :type => :rect, :width=>35, :height=>35, :friction=>1 })
				end
		
				def _setupConfig
					super
					self._setupElements
				end
		
			public
				def bgColor
					@bgColor
				end
		
				def bgColor=(value)
					if (value.is_a? Array)
						@bgColor = Array.new(4) { |i| Gosu::Color.new(value[i%value.size].to_i(16)) }
					else
						@bgColor = Array.new(4, Gosu::Color.new(value.to_i(16)))
					end
				end
		
				def update
					super
				end
		
				def draw
					# Draw gradient background, from @bgColor
					$window.draw_quad(self.parent().viewport.x, self.parent().viewport.y, @bgColor[0], self.parent().viewport.x+$window.width, 0, @bgColor[1], self.parent().viewport.x+$window.width, self.parent().viewport.y+$window.height, @bgColor[2], 0, self.parent().viewport.y+$window.height, @bgColor[3]) unless (@bgColor.nil?);
					super
				end
		end
		
		class Map < BaseMap
			def initialize(options)
				super($config[options[:config]].merge(options))

				@parallaxes = []

				tmp = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => 1)
				tmp.add_layer(:image => File.join(GFX, 'BLUE_GRASS_BG_1.png'), :damping => 200, :center => 0)
				@parallaxes << tmp
		
				tmp = Chingu::Parallax.create(:x => 0, :y => 813, :rotation_center => :top_left, :zorder => 10)
				tmp << {:image => File.join(GFX, 'BLUE_GRASS_FG_1.png'), :y=>0, :damping => 1, :center => 0}
				@parallaxes << tmp
		
				tmp = Chingu::Parallax.create(:x => 0, :y => tmp.y-30, :rotation_center => :top_left, :zorder => 10)
				tmp << {:image => File.join(GFX, 'BLUE_GRASS_FG_2.png'), :y=>0, :damping => 1, :center => 0}
				@parallaxes << tmp
		
				tmp = Chingu::Parallax.create(:x => 0, :y => tmp.y-30, :rotation_center => :top_left, :zorder => 2)
				tmp << {:image => File.join(GFX, 'BLUE_GRASS_BG_3.png'), :y=>0, :damping => 1, :center => 0}
				@parallaxes << tmp
			end

			def update
				# Update parallaxes
				@parallaxes.each do |parallax|
					parallax.camera_x = @parent.viewport.x
					parallax.camera_y = @parent.viewport.y
				end

				super
			end
		end
	end
end