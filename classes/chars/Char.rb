require 'gosu'
require 'chingu'
require 'chipmunk'

Kernel.r 'weapon/Weapon.rb'

class Char < Chingu::GameObject
	attr_accessor :weapons, :body, :shape

	def initialize(options)
		@weapons = WeaponManager.new(self)
		@turned = 1

		self._setupBody

		@maxVX = 100

		if !options[:image_prefix].nil?
			@images = [$imageManager['birds'].sprites[options[:image_prefix]+'_1'].image, $imageManager['birds'].sprites['BIRD_RED_BLINK'].image]
		end

		self._setupShape()

		@jumpImpulse = CP::Vec2.new(0,-70)

		#options[:center_x] = options[:center_y] = 0.5

		super(options)

		self.parent().space.add_body(self.body)
		self.parent().space.add_shape(self.shape)

		self._setupCrossHair
	end

	protected
		def _initBody
			CP::Body.new(2, Geasy::INFINITY)
		end

		def _setupBody
			@body = self._initBody
			self.body.p.x += 155
			self.body.v_limit = 50
			self.body.object = self
		end

		def _initShape
			CP::Shape::Circle.new(self.body, 17, CP::Vec2.new(5,7))
		end

		def _setupShape
			@shape = self._initShape
			self.shape.object = self
			self.shape.e = 0.7
			self.shape.u = 0.5
			self.shape.collision_type = :Char
		end

		def _setupCrossHair
			@crossHair = Chingu::GameObject.create(:image => Gosu::Image.new($window, 'gfx/crosshair.png'), :center_x => 0.5, :center_y => 0.5)
			@crossHairRadius = 50
		end

	public
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
			@turned = -1.0
		end
	
		def turnRight
			@turned = 1.0
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

		def startChangeAngle
			self.weapons().startChangeAngle
		end

		def incAngle
			self.weapons().incAngle
		end

		def decAngle
			self.weapons().decAngle
		end
	
		def update
			super
	
			# Synchronizes the body and Gosu properties
			self.image = @images[(((Gosu::milliseconds % 1100) > 1000)?1:0)]

			self.factor_y = 1 - (self.body.v.y/self.body.v_limit)*0.1
			self.factor_x = @turned + (self.body.v.y/self.body.v_limit)*0.1*@turned

			self.x = self.body.p.x
			self.y = self.body.p.y

			@crossHair.x = self.x + (@crossHairRadius*Math.cos(self.weapons.angle))*@turned
			@crossHair.y = self.y + (@crossHairRadius*Math.sin(self.weapons.angle))
		end

		def draw()
			super
			$window.draw_line(self.x-1, self.y-1, Gosu::black, self.x+1, self.y+1, Gosu::black, 100000000)
		end
end
