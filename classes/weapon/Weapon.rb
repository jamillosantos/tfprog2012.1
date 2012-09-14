
require 'chingu'
require 'chipmunk'
require 'geasy'

Kernel.r 'base/Object.rb'
Kernel.r 'animation/Explosion.rb'

module MadBirds
	module Base
		class Bullet < MadBirds::Base::Object
		
			traits :timer
		
			def initialize(options)
				@weapon = options[:weapon]
		
				@destroing = false
		
				options[:collisionType] = :Bullet
		
				r = 30
				options[:x] = @weapon.weaponManager.char.x + self.char.turned*r*Math.cos(options[:angle] || @weapon.weaponManager.angle)
				options[:y] = @weapon.weaponManager.char.y + r*Math.sin(options[:angle] || @weapon.weaponManager.angle)
		
				super(options)
			end
		
			protected
			
				def _afterSetups
					r = 75
					self.body.a = (@weapon.weaponManager.angle + Math::PIH)*self.char.turned
					self.body.apply_impulse(CP::Vec2.new(self.char().body.v.x + self.char.turned*r*Math.cos(@weapon.weaponManager.angle), self.char().body.v.y + r*Math.sin(@weapon.weaponManager.angle)), Geasy::VZERO)
					super
				end
		
			public
		
				def char
					@weapon.weaponManager.char
				end
			
				def update
					# Sync the bullet angle with the velocity, with angle correction
					self.body.a = self.body.v.to_angle + Math::PIH
					super
				end
		
				def destroying?
					@destroying
				end
			
				def explode(point = nil)
					r = 50
					unless @destroying
						point = CP::Vec2.new(self.x, self.y) unless point

						MadBirds::Animation::Explosion.create(:x => point.x, :y => point.y)
						@destroying = true
						self.parent.game_objects.each do |object|
							if (object.is_a? MadBirds::Base::Object) && (object.body.p.near?(self.body.p, r))
								if (object.is_a? Bullet)
									object.explode unless object.destroying?
								else
									object.body.apply_impulse((object.body.p-self.body.p)*@weapon.power*3, Geasy::VZERO)
								end
							end
						end
						self.destroy
					end
				end
		end
		
		class Missile < Bullet
			def initialize(options)
				options[:image] = File.join(GFX, 'bullets', 'missile.png')
				options[:friction] = 1
				options[:elasticity] = 0.3
				options[:shapes] = { :type => :rect, :width => 12, :height => 22 }
				options[:body] = { :weight => 1, :moment => 1000 }
				super(options)
			end
		end

		class Weapon
			attr_reader :weaponManager, :char
			attr_accessor :amount, :power, :spread, :delay, :recoil, :rechargeTime
		
			def initialize (options = {})
				@weaponManager = options[:weaponManager]
				@char = @weaponManager.char
		
				self.amount = options[:amount] || 1
				self.power = options[:power] || 1
				self.spread = options[:spread] || 0
				self.delay = options[:delay] || 0
				self.recoil = options[:recoil] || 0
				self.rechargeTime = options[:rechargeTime] || 1
			end
		
			public
		
				def weaponManager
					@weaponManager
				end
		
				def char
					@weaponManager.char
				end
		
				# Bullets fired every shot
				def amount
					@amount
				end
		
				def amount=(value)
					@amount = value
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
					angle = self.weaponManager.angle
					self.amount.times do |a|
						Missile.create(:weapon => self, :angle => angle)
					end
		
					r = -self.recoil;
					self.char.body.apply_impulse(CP::Vec2.new(self.char.turned*r*Math.cos(self.weaponManager.angle), r*Math.sin(self.weaponManager.angle)), Geasy::VZERO)
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
				@weapons = [Weapon.new({ :weaponManager=>self, :amount => 1, :power=>3, :recoil => 30 })]
				self.next()
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
		
			public
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
		end
	end
end