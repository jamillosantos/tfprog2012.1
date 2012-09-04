
class Array
	def toVec2()
		if self.first.is_a? Array
			self.map do |v|
				v.toVec2()
			end
		else
			CP::Vec2.new(self[0], self[1])
		end
	end
end

module CP
	class Vec2
		def toVec2
			self
		end
	end

	module Shape
		def self.fromObject(body, obj)
			unless obj[:offset].nil?
				offset = obj[:offset].toVec2
			else
				offset = Geasy::VZERO
			end

			case obj[:type].to_sym
			when :circle
				result = CP::Shape::Circle.new(body, obj[:radius], offset)
			when :rect
				w = (obj[:width]/2.0)
				h = (obj[:height]/2.0)
				result = CP::Shape::Poly.new(body, [CP::Vec2.new(-w, h), CP::Vec2.new(w, h), CP::Vec2.new(w, -h), CP::Vec2.new(-w, -h)], offset)
			when :poly
				if (obj[:offset].nil?)
					result = CP::Shape::Poly.new(body, obj[:verts].toVec2, Geasy::VZERO)
				else
					result = CP::Shape::Poly.new(body, obj[:verts], (obj[:offset].is_a?(CP::Vec2) ? obj[:offset] : obj[:offset].toVec2))
				end
			when :segment
				result = CP::Shape::Segment.new(body, (obj[:vecA].is_a?(CP::Vec2) ? obj[:vecA] : obj[:vecA].toVec2 ), (obj[:vecB].is_a?(CP::Vec2) ? obj[:vecB] : obj[:vecB].toVec2 ), obj[:vecB])
			else
				raise ArgumentError.new('Invalid shape object: ' + obj.inspect)
			end
			result.e = obj[:elasticity] || result.e 
			result.u = obj[:friction] || result.u
			result
		end
	end
end
