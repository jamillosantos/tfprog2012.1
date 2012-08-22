
require 'gosu'
require 'chingu'
require 'geasy'
require 'clipper'

class BaseMap < Geasy::CPObject

	attr_reader :verts, :clipper

	def verts
		@verts
	end

	def difCircle(x, y, radius, q = 10)
		r = Math::PI2*2/q
		#self.clipper.add_clip_polygon(q.times.map { |i| [x+radius*Math.cos(tmpr = r*i), y+radius*Math.sin(tmpr)] })
		self.clipper.add_clip_polygon([[100, 283],[200, 283],[150, 383]].reverse)
		@verts = self.clipper.difference(:non_zero, :non_zero).first
		puts @verts.inspect
		self._updateVerts
	end

	def initialize(options)
		self._setupClipper
		super(options)
	end

	def clipper
		@clipper
	end

	protected
		def _initClipper
			Clipper::Clipper.new
		end

		def _setupClipper
			@clipper = self._initClipper
		end

		def _initBody
			CP::Body.new(Geasy::INFINITY, Geasy::INFINITY)
		end

		def _setupBody
			super
			self.body.p = CP::Vec2.new(0, 0)
		end

		def _initShapes
			@verts = [[0.0, 483.0], [1000.0, 483.0], [1000.0, 283.0], [0.0, 283.0]]
			self.clipper.add_subject_polygon(@verts)
			[CP::Shape::Poly.new(self.body, self._buildVerts(), Geasy::VZERO)]
		end

		def _buildVerts
			result = []
			@verts.each do |v|
				result << CP::Vec2.new(v[0], v[1])
			end
			result
		end

		def _updateVerts
			self.shapes()[0].set_verts!(self._buildVerts(), Geasy::VZERO)
		end
end

class Map < BaseBap
end
