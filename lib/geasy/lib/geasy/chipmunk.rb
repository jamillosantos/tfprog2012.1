
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
