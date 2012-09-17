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

			def damage(object, value)
				@health -= value
				if @health < 0
					self.die!(object.char.player) # Pensando que este implemente o Chingu::GameObject
				end
			end

			def die!(how)
				@died = true
				if (self.player == how)
					how.kills -= 1
					puts 'LifeObject::die!', 'decrease'
				else
					puts 'LifeObject::die!', 'increase'
					how.kills += 1
				end
			end

			def died?
				@died == true
			end
		end
	end
end