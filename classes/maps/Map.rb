
require 'gosu'
require 'chingu'
require 'geasy'
require 'clipper'

class BaseMap < Geasy::CPObject

	def initialize(options)
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
				a = nil
				b = 123
				puts a || b
				if shape[:type] == "poly"
					result = CP::Shape::Poly.new(self.body, shape[:verts].toVec2, ((shape[:offset].nil?)? Geasy::VZERO : shape[:offset].toVec2))
				elsif shape[:type] == "circle"
					result = CP::Shape::Circle.new(self.body, shape[:radius], ((shape[:offset].nil?)? Geasy::VZERO : shape[:offset].toVec2))
				else
					raise ArgumentError.new('Forma "%s" não implementada.' % shape.type)
				end
				result.e = shape[:elasticity] unless shape[:elasticity].nil? 
				result.u = shape[:friction] unless shape[:friction].nil?
				
				puts result.e.inspect
				result
			end unless @setupOptions[:shapes].nil?;
		end
end

class Map < BaseMap
	def initialize(options)
		super($config[options])
	end
end
