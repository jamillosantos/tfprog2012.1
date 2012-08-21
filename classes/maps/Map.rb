
require 'gosu'
require 'chingu'
require 'geasy'

class Map < Geasy::CPObject

	def initialize(url)
		super({})
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
			verts = [CP::Vec2.new(0, 283), CP::Vec2.new(1000, 283), CP::Vec2.new(1000, 483), CP::Vec2.new(0, 483)].reverse()
			puts verts
			[CP::Shape::Poly.new(self.body, verts, CP::Vec2.new(50,500))]
		end

	public
end

