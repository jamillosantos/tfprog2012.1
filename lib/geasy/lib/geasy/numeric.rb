
class Numeric

	def radians
		self / 180.0 * Math::PI
	end

	def degrees
		(self / Math::PI) * 180.0
	end
end