require 'gosu'
require 'chingu'
require 'chipmunk'

Kernel.r 'weapon/Weapon.rb'

class Char < Chingu::GameObject
	attr_accessor :weapons, :body, :shape, :strength

	def initialize(options)
		@config = $config['chars/' + options]

		@weapons = WeaponManager.new(self)
		@turned = 1

		super({})

		unless @config[:center].nil?
			self.center_x = @config[:center][:x] unless @config[:center][:x].nil?
			self.center_y = @config[:center][:y] unless @config[:center][:y].nil?
		end

		self._setupBody

		@maxVX = 30

		@strength = @config[:strength]

		if !@config[:imagePrefix].nil?
			@images = [$imageManager[:birds].sprites[(@config[:imagePrefix]+'_1').to_sym].image, $imageManager[:birds].sprites[(@config[:imagePrefix] + '_BLINK').to_sym].image]
		end

		self._setupShape()

		@jumpImpulse = CP::Vec2.new(0, -100*self.strength)

		self._setupCrossHair
	end

	protected

		def _initBody
			CP::Body.new(@config[:body][:weight], Geasy::INFINITY)
		end

		def _setupBody
			@body = self._initBody

			#self.body.p.x = 50 + $window.width*rand() - 100 
			#self.body.p.y = 0
			
			#self.body.v_limit = 50
			self.body.object = self
			self.parent().space.add_body(self.body)
		end

		def _initShape
			shape = $config['Shapes'][@config[:shape][:id].to_sym]
			if shape[:type] == 'CIRCLE'
				CP::Shape::Circle.new(self.body, shape[:radius], CP::Vec2.new(shape[:offsetX], shape[:offsetY]))
			end
		end

		def _setupShape
			@shape = self._initShape
			shape = @config[:shape]
			self.shape.object = self
			self.shape.e = shape[:elasticity]
			self.shape.u = shape[:friction]
			self.shape.collision_type = shape[:collision].to_sym
			self.parent().space.add_shape(self.shape)
		end

		def _setupCrossHair
			@crossHair = Chingu::GameObject.create(:image => Gosu::Image.new($window, 'gfx/crosshair.png'), :center_x => 0.5, :center_y => 0.5)
			@crossHairRadius = @config[:crosshair][:radius]
		end

	public
		def weapons
			@weapons
		end

		def strength
			@strength
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
			@groundKickTime ||= 0
			puts 'Char::groundKick'
			if ((Gosu::milliseconds - @groundKickTime) > 300)
				Gosu::Sound["Bird_Red_Collision_2.mp3.wav"].play
				@groundKickTime = Gosu::milliseconds()
			end
		end

		def moveLeft
			self.turnLeft
			if (self.grounded?)
				i = 3
			else
				i = 1
			end
			if (self.body.v.x > 0)
				i *= 3
			end
			self.body.v.x = Math.max(self.body.v.x - i, -@maxVX)
		end
	
		def moveRight
			self.turnRight
			if (self.grounded?)
				i = 3
			else
				i = 1
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

			# Blink
			self.image = @images[(((Gosu::milliseconds % 5100) > 5000)?1:0)]

			# Velocity deformation
			self.factor_y = 1 - (self.body.v.y/self.body.v_limit)*0.1
			self.factor_x = @turned + (self.body.v.y/self.body.v_limit)*0.1*@turned

			# Sync with Chipmunk
			self.x = self.body.p.x
			self.y = self.body.p.y

			self.angle = @body.a.degrees
			# puts self.angle

			puts self.body().p.inspect, self.body().v.inspect, self.shape.surface_v, '--------'

			# self.body().t = 1

			# Crosshair
			@crossHair.x = self.x + (@crossHairRadius*Math.cos(self.weapons.angle))*@turned
			@crossHair.y = self.y + (@crossHairRadius*Math.sin(self.weapons.angle))
		end

		def draw
			super
			$window.gl {
				glBegin(GL_LINE_LOOP); 
					glVertex2f(self.x - self.parent().viewport.x, self.y - self.parent().viewport.y)
					20.times do |ii|
						theta = 2 * Math::PI * ii / 20.0
						glVertex2f(self.x - self.parent().viewport.x + (17 * Math.cos(theta)), self.y - self.parent().viewport.y + 17 * Math.sin(theta)) 
					end
					theta = 2 * Math::PI * 0 / 20.0
					glVertex2f(self.x - self.parent().viewport.x + (17 * Math.cos(theta)), self.y - self.parent().viewport.y + 17 * Math.sin(theta)) 
					glEnd() 
			}
		end
end
