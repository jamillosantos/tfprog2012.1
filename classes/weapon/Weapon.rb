require 'chingu'
require 'chipmunk'
require 'geasy'

Kernel.r 'base/Object.rb'
Kernel.r 'animation/Explosion.rb'
Kernel.r 'particles/Smoke.rb'

module MadBirds
	module Base
		class Bullet < MadBirds::Base::Object

			traits :timer
			def initialize(options)
				@weapon = options[:weapon]

				@destroying = false

				options[:collisionType] = :Bullet

				r = 30
				options[:x] = @weapon.weaponManager.char.x + self.char.turned*r*Math.cos(options[:angle] || @weapon.weaponManager.angle)
				options[:y] = @weapon.weaponManager.char.y + r*Math.sin(options[:angle] || @weapon.weaponManager.angle)

				self.damage = options[:damage] || 10

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

			# Dano máximo da `Bullet`
			def damage
				@damage
			end

			def damage=(value)
				@damage = value
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

					MadBirds::Animation::Explosion.create(:x => point.x, :y => point.y, :parent=>self.parent)
					@destroying = true
					self.parent.game_objects.each do |object|
						if (object.is_a? MadBirds::Base::Object) && (object.body.p.near?(self.body.p, r))
							if (object.is_a? Bullet)
								object.explode unless object.destroying?
							else
								object.damage(self, self.damage * (object.body.p.dist(self.body.p)/r)) if object.is_a? MadBirds::Base::LifeObject
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
				options[:damage] = 200
				options[:friction] = 1
				options[:elasticity] = 0.3
				options[:shapes] = { :type => :rect, :width => 12, :height => 22 }
				options[:body] = { :weight => 1, :moment => 1000 }
				@particles = []
				super(options)
			end

			def update
				super

				if ((Gosu::milliseconds - (@lastParticle || 0)) > 100)
					@lastParticle = Gosu::milliseconds
					MadBirds::Particles::Smoke.create({
						:x => self.x,
						:y => self.y,
						:parent=>self.parent
					})
				end
			end
		end

		class Cartridge
			attr_accessor :amount, :length
			def initialize(options)
				self.length = options[:length] || 1
				self.proportion = options[:proportion] || 1
				self.amount = options[:amount] || 1
			end

			public

			# Reload proportion
			def proportion
				@proportion
			end

			def proportion=(value)
				@proportion = value
			end

			def amount
				@amount
			end

			def amount=(value)
				@amount = Math.min(value, self.length)
			end

			def length
				@length
			end

			def length=(value)
				@length = value
			end

			def reload()
				self.amount = self.length
			end

			def reloadStep()
				self.amount += (@length*@proportion).round
			end
		end

		class Weapon
			attr_reader :weaponManager, :char, :cartridge
			attr_accessor :amount, :power, :delay, :recoil, :reloadTime, :cartridge
			def initialize (options = {})
				@weaponManager = options[:weaponManager]
				@char = @weaponManager.char

				@cartridge = Cartridge.new({})

				self.amount = options[:amount] || 1
				self.power = options[:power] || 1
				self.delay = options[:delay] || 0
				self.recoil = options[:recoil] || 0
				self.reloadTime = options[:reloadTime] || 1
			end

			protected

			def shootBullet
			end

			public

			def weaponManager
				@weaponManager
			end

			def char
				@weaponManager.char
			end

			def cartridge
				@cartridge
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

			# Delay between shoots
			def delay
				@delay
			end

			def delay=(value)
				@delay = value
			end

			# Reload delay
			def reloadTime
				@reloadTime
			end

			def reloadTime=(value)
				@reloadTime = value
			end

			# Shoot the particle
			def shoot
				if (((Gosu::milliseconds-(@shootTime || 0)) > @reloadTime) && (@cartridge.amount > 0))
					@shootTime = Gosu::milliseconds
					self.shootBullet
					@cartridge.amount -= 1

					# Apply recoil
					r = -self.recoil;
					self.char.body.apply_impulse(CP::Vec2.new(self.char.turned*r*Math.cos(self.weaponManager.angle), r*Math.sin(self.weaponManager.angle)), Geasy::VZERO)
				end
			end

			def startReload
				@reload_start = Gosu::milliseconds
			end

			def checkReload
				if ((Gosu::milliseconds - @reload_start) >= @reloadTime)
					@cartridge.reloadStep
				end
			end

			def stopReload
			end
		end

		class Bazooka < Weapon
			protected
			def shootBullet
				Missile.create(:weapon => self, :angle => @weaponManager.angle, :parent=>self.char.parent)
			end
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
				@weapons = [Bazooka.new({ :weaponManager=>self, :amount => 1, :power=>3, :recoil => 30, :reloadTime => 100 })]
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

			def startReload
				@current.startReload
			end

			def checkReload
				@current.checkReload
			end

			def stopReload
				@current.stopReload
			end

		end
	end
end