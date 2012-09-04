
require 'chingu'
require 'chipmunk'
require 'geasy'

class Bullet < Geasy::CPObject

	def initialize(options)
		puts 'Bullet::initialize'
		@weapon = options[:weapon]
		options[:colisionType] = :Bullet
		options[:x] = @weapon.weaponManager.char.x
		options[:y] = @weapon.weaponManager.char.y

		@lastV = CP::Vec2.new(0, 0)

		super(options)
	end

	def char
		@weapon.weaponManager.char
	end

	def _afterSetups
		r = 100
		self.body.a = (@weapon.weaponManager.angle + Math::PIH)*self.char.turned
		self.body.apply_impulse(CP::Vec2.new(self.char.turned*r*Math.cos(@weapon.weaponManager.angle), r*Math.sin(@weapon.weaponManager.angle)), Geasy::VZERO)
		super
	end

	def update
		puts self.body.v.inspect, @lastV.inspect, '---'
		@lastV.x, @lastV.y = self.body.v.x, self.body.v.y
		self.body.a = Math.tan(self.body.v.x/self.body.v.y) unless self.body.v.y == 0 
		super
	end
end

class Missile < Bullet
	def initialize(options)
		options[:image] = File.join(GFX, 'bullets', 'missile.png')
		options[:shape] = { :type => :rect, :width => 12, :height => 22, :offset => [6, 0] }
		options[:body] = { :weight => 1, :moment => 10000 }
		super(options)
	end
end

class Weapon
	attr_reader :weaponManager
	attr_accessor :power, :spread

	def initialize (wmanager)
		@weaponManager = wmanager
		@char = wmanager.char
	end

	def weaponManager
		@weaponManager
	end

	# Weapon destruciton power
	def power
		@power
	end

	def power=(value)
		@power = value
	end

	# Weapon particle spread, in radians
	def spread
		@spread
	end

	def spread=(value)
		@spread = value
	end

	# Delay between shoots
	def delay
		@delay
	end

	def delay=(value)
		@delay = value
	end

	# Recharge delay
	def rechargeTime
		@rechargeTime
	end

	def rechargeTime=(value)
		@rechargeTime = value
	end

	def shoot
		Missile.create(:weapon => self)
	end

	def recharge
		#
	end
end

class WeaponBlaster < Weapon
end

class WeaponManager
	# Angle velocity change
	ANGLE_PER_MS = Math::PI/2000

	attr_accessor :index, :current, :angle, :maxAngle, :char

	def initialize(char)
		@angle = 0.0
		@idxAngle = 0.0
		@maxAngle = ((Math::PI/6)*5)
		@index = -1

		@char = char
		@weapons = [Weapon.new(self)]
		self.next()
	end

	# Char which have this weapon manager
	def char
		@char
	end

	# Current weapon index
	def index
		@index
	end

	# Shot angle
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

	# Start the angle rotation
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

	# Current weapon object reference
	def current
		@current
	end

	# Change to next weapon
	def next
		@index += 1
		self._update
		self
	end

	# Change to previous weapon
	def prev
		@index -= 1
		self._update
		self
	end

	# Fire the particle shot
	def shoot
		# Project
		@current.shoot
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
