
require 'gosu'
require 'chingu'
require 'geasy'
require 'clipper'

class BaseMap < Geasy::CPObject

	attr_accessor :bgColor

	def initialize(options)
		self.bgColor = options[:bgColor] unless options[:bgColor].nil?
		super(options)
	end

	protected
		def _initBody
			CP::Body.new(Geasy::INFINITY, Geasy::INFINITY)
		end

		def _setupBody
			super
			self.body.p = CP::Vec2.new(0, 0)
		end

		def _initShapes
			@setupOptions[:shapes].map do |shape|
				if shape[:type] == "poly"
					result = CP::Shape::Poly.new(self.body, shape[:verts].toVec2, ((shape[:offset].nil?)? Geasy::VZERO : shape[:offset].toVec2))
				elsif shape[:type] == "circle"
					result = CP::Shape::Circle.new(self.body, shape[:radius], ((shape[:offset].nil?)? Geasy::VZERO : shape[:offset].toVec2))
				else
					raise ArgumentError.new('Forma "%s" não implementada.' % shape.type)
				end
				result.e = shape[:elasticity] || @setupOptions[:elasticity] || result.e 
				result.u = shape[:friction] || @setupOptions[:friction] || result.u
				result
			end unless @setupOptions[:shapes].nil?;
		end

	public
		def bgColor
			@bgColor
		end

		def bgColor=(value)
			if (value.is_a? Array)
				@bgColor = Array.new(4) { |i| value[i%@bgColor.size] }
			else
				puts value.inspect, value.to_i
				@bgColor = Array.new(4, Gosu::Color.new(value.to_i))
			end
		end

		def draw
			$window.draw_quad(0, 0, @bgColor[0], $window.width, 0, @bgColor[1], $window.width, $window.height, @bgColor[2], 0, $window.height, @bgColor[3]) unless (self.bgColor.nil?);
			super
		end
end

class Map < BaseMap
	def initialize(options)
		super($config[options])
	end
end
