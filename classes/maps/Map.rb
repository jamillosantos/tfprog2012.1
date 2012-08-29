
require 'gosu'
require 'chingu'
require 'geasy'
require 'clipper'

class MapElement < Geasy::CPObject
	def initialize(args)
		super(args)
	end
end

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
			MapElement.create(:space=>self.space,:image=>$imageManager.ids(:WOOD_CIRCLE_4X4).image, :x=>150, :y=>10, :body=>{ :weight=>1, :moment=>Geasy::INFINITY }, :shapes=>{ :type => :circle, :radius=>50, :offset=>CP::Vec2.new(25, 25) })
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
			puts self.body().p.inspect
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
	end
end
