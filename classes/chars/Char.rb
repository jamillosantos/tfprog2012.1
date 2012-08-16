require 'gosu'
require 'chingu'
require 'chipmunk'

Kernel.r 'weapon/Weapon.rb'

class Char < Chingu::GameObject
	attr_accessor :weapons, :body, :shape

	def initialize(options)
		@weapons = WeaponManager.new(self)
		@body = CP::Body.new(2, Geasy::INFINITY)
		self.body.p.x += 155
		self.body.v_limit = 50
		self.body.object = self

		@maxVX = 100

		if !options[:image_prefix].nil?
			puts $imageManager['birds'].sprites[options[:image_prefix]+'_1'].inspect
			@images = [$imageManager['birds'].sprites[options[:image_prefix]+'_1'].image, $imageManager['birds'].sprites['BIRD_RED_BLINK'].image]
		end

		@shape = CP::Shape::Circle.new(self.body, 17, CP::Vec2.new(5,7))
		self.shape.object = self
		self.shape.e = 0.7
		self.shape.u = 0.5
		self.shape.collision_type = :Char

		@jumpImpulse = CP::Vec2.new(0,-70)

		super(options)
		self.parent().space.add_body(self.body)
		self.parent().space.add_shape(self.shape)
	end

	def weapons
		@weapons
	end

	def body
		@body
	end

	def shape
		@shape
	end

	def startJump
		puts 'Char::startJump'
		self
	end

	def jump
		puts 'Char::jump'
		self.body.apply_impulse(@jumpImpulse, CP::Vec2.new(0, 0))
		self
	end

	def turnLeft
		@turned = :left
	end

	def turnRight
		@turned = :right
	end

	#
	# Verifica se o personagem está no chão
	# @TODO Desfazer este arranjado e implementar de verdade ...
	#
	def grounded?
		(self.body.v.y == 0)
	end

	def groundKick
		#self.factor_x = 0.5
	end

	def moveLeft
		self.turnLeft
		if (self.grounded?)
			i = 1
		else
			i = 0.3
		end
		if (self.body.v.x > 0)
			i *= 3
		end
		self.body.v.x = Math.max(self.body.v.x - i, -@maxVX)
	end

	def moveRight
		self.turnRight
		if (self.grounded?)
			i = 1
		else
			i = 0.3
		end
		if (self.body.v.x < 0)
			i *= 3
		end
		self.body.v.x = Math.min(self.body.v.x + i, @maxVX)
	end

	def update
		super

		# Synchronizes the body and Gosu properties
		self.image = @images[(((Gosu::milliseconds % 1100) > 1000)?1:0)]
		self.factor_y = 1 - (self.body.v.y/self.body.v_limit)*0.1
		# self.shape().radius = 17 * self.factor_y;
		self.center_y = self.factor_y/2
		self.factor_x = ((@turned == :left)? -1 : 1) + (self.body.v.y/self.body.v_limit)*0.2

		#puts self.shape().radius
		self.x = self.body.p.x
		self.y = self.body.p.y
	end
end
