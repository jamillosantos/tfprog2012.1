
require 'gosu'
require 'chingu'
require 'chipmunk'
require 'geasy'

Kernel.r 'base/Object.rb'
Kernel.r 'weapon/Weapon.rb'

module MadBirds
	class Char < Base::Object
		attr_accessor :weapons, :body, :shape, :strength, :turned

		def initialize(options)
			@weapons = Base::WeaponManager.new(self)
			@turned = 1
	
			super($config['chars/' + options].merge({ :collisionType => :Char }))
		end
	
		protected
	
			def _setupConfig
				super
		
				unless @setupOptions[:center].nil?
					self.center_x = @setupOptions[:center][:x] unless @setupOptions[:center][:x].nil?
					self.center_y = @setupOptions[:center][:y] unless @setupOptions[:center][:y].nil?
				end
		
				@maxVX = 20
	
				@strength = @setupOptions[:strength]
	
				if !@setupOptions[:imagePrefix].nil?
					@images = [$imageManager[:birds].sprites[(@setupOptions[:imagePrefix]+'_1').to_sym].image, $imageManager[:birds].sprites[(@setupOptions[:imagePrefix] + '_BLINK').to_sym].image]
				end
				@jumpImpulse = CP::Vec2.new(0, -100*self.strength)
		
				self._setupCrossHair
			end
	
			def _setupBody
				super()
				self.body().v_limit = 70
			end
	
			def _setupCrossHair
				@crossHair = Chingu::GameObject.create(:image => Gosu::Image.new($window, 'gfx/crosshair.png'), :center_x => 0.5, :center_y => 0.5)
				@crossHairRadius = @setupOptions[:crosshair][:radius]
			end
	
		public
			def weapons
				@weapons
			end
	
			def strength
				@strength
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
	
			def turned
				@turned
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
	
			def move
				self.body.v.x = Math.min(Math.max(self.body.v.x + (2*@turned), -@maxVX), @maxVX)
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
	
			def shoot
				@weapons.shoot
			end
	end
end
