
class WeaponManager
	# Angle velocity change
	ANGLE_PER_MS = Math::PI/2000

	attr_accessor :index, :current, :angle, :maxAngle

	def initialize(char)
		@angle = 0.0
		@idxAngle = 0.0
		@maxAngle = ((Math::PI/6)*5)

		@char = char
		@weapons = []
	end

	def index
		@index
	end

	def angle
		@angle
	end

	# Max radian angle
	def maxAngle
		@maxAngle
	end

	def maxAngle=(value)
		@maxAngle = value
		self
	end

	def startChangeAngle
		@startChangeAngle = Gosu::milliseconds()
	end

	# Increase the angle
	def incAngle
		@idxAngle = Math.max(0, @idxAngle - (ANGLE_PER_MS*(Gosu::milliseconds()-@startChangeAngle)))
		self.startChangeAngle()
		self._updateAngle()
	end

	# Decrease the angle
	def decAngle
		@idxAngle = Math.min(1, @idxAngle + (ANGLE_PER_MS*(Gosu::milliseconds()-@startChangeAngle)))
		self.startChangeAngle()
		self._updateAngle()
	end

	# Current weapon
	def current
		@current
	end

	# Next weapon
	def next
		@index += 1
		self._update
		self
	end

	# Previous weapon
	def prev
		@index -= 1
		self._update
		self
	end

	# Fire the shoot particle
	def fire
		# Project
		self.current.fire
		self
	end

	##############

	protected

		# Update the current weapon index. Must be called after index change
		def _update
			@index = (@index % @weapons.size)
			@current = @weapons[@index]
		end

		# Make the angle transformation
		def _updateAngle
			@angle = (@maxAngle*@idxAngle) - Math::PIH
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

	def recoil
	end
end
