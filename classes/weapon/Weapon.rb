
class WeaponManager
	attr_accessor :index, :current

	def initialize(char)
		@char = char
		@weapons = []
	end

	def index
		@index
	end

	def angle
		@angle
	end

	def angle=(value)
		@angle = value
		self
	end

	def current
		@current
	end

	def next
		@index += 1
		self._update
		self
	end

	def prev
		@index -= 1
		self._update
		self
	end

	def fire
		# Project
		self.current.fire
		self
	end

	##############

	protected

	def _update
		@index = (@index % @weapons.size)
		@current = @weapons[@index]
	end
end

class Weapon
	attr_accessor :power, :spread

	def power
		@power
	end

	def power=(value)
		@power = value
	end

	def spread
		@spread
	end

	def spread=(value)
		@spread = value
	end

	def delay
		@delay
	end

	def delay=(value)
		@delay = value
	end

	def fire
	end

	def recharge
	end
end
