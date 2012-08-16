require 'gosu'
require 'chingu'
require 'chipmunk'

Kernel.r 'weapon/Weapon.rb'

class Char < Chingu::GameObject
	attr_accessor :weapons
	def initialize(options)
		@weapons = WeaponManager.new(self)
		@body = CP::Body.new(2, Geasy::INFINITY)
		@body.p.x += 155
		@body.v_limit = 50

		@maxVX = 100

		if !options[:image_prefix].nil?
			puts $imageManager['birds'].sprites[options[:image_prefix]+'_1'].inspect
			@images = [$imageManager['birds'].sprites[options[:image_prefix]+'_1'].image, $imageManager['birds'].sprites['BIRD_RED_BLINK'].image]
		end
		@shape = CP::Shape::Circle.new(@body, 17, CP::Vec2.new(5,7))
		@shape.e = 0.7
		@shape.u = 0.5
		@shape.collision_type = :Char

		@jumpImpulse = CP::Vec2.new(0,-70)

		super(options)
		self.parent().space.add_body(@body)
		self.parent().space.add_shape(@shape)
	end

	def weapons
		@weapons
	end

	def jump
		puts 'Char::jump'
		@body.apply_impulse(@jumpImpulse, CP::Vec2.new(0, 0))
		self
	end

	def turnLeft
		self.factor_x = -1
	end

	def turnRight
		self.factor_x = 1
	end

	#
	# Verifica se o personagem está no chão
	# @TODO Desfazer este arranjado e implementar de verdade ...
	#
	def grounded?
		(@body.v.y == 0)
	end

	def moveLeft
		self.turnLeft
		if (self.grounded?)
			i = 1
		else
			i = 0.3
		end
		if (@body.v.x > 0)
			i *= 3
		end
		@body.v.x = Math.max(@body.v.x - i, -@maxVX)
	end

	def moveRight
		self.turnRight
		if (self.grounded?)
			i = 1
		else
			i = 0.3
		end
		if (@body.v.x < 0)
			i *= 3
		end
		@body.v.x = Math.min(@body.v.x + i, @maxVX)
	end

	def update
		super
		self.x = @body.p.x
		self.y = @body.p.y
		# puts @body.v
		# puts @body.f
		@a ||= 0
		# @a = (@a + 0.02) % @images.length()
		self.image = @images[@a.floor]
	end
end
