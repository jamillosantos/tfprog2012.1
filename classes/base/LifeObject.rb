module MadBirds
	module Base
		module LifeObject
			attr_accessor :life, :health

			def life
				@life
			end

			def life=(value)
				@health = value if @life.nil?
				@life = value
				self
			end

			def health
				@health
			end

			def health=(value)
				@health = value
				self
			end

			def fullHealth
				@health = @life
				self
			end

			def injuried?
				@health/@life < 0.1
			end

			def damage(value)
				@health -= value
				print 'LifeObject::damage: ', '-', value.inspect, ' : ', @health, ' from ', @life
				if @health < 0
					self.die! # Pensando que este implemente o Chingu::GameObject
				end
			end

			def die!
			end
		end
	end
end