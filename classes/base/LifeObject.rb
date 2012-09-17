module MadBirds
	module Base
		module LifeObject
			attr_accessor :life, :health, :healthImage

			def initializeLifeObject(options)
				self.life = options[:life] || 100
				self.health = options[:health] unless options[:health].nil?
				self.healthImage = options[:healthImage] unless options[:healthImage].nil?
			end

			def healthImage
				@healthImage
			end

			def healthImage=(value)
				@healthImage
			end

			def updateHealthImage
				unless @healthImage.nil?
					i = ((@health/@life)*100).round
					@healthImage.each do |k, v|
						if (k.cover? i)
							self.image = v
							break
						end
					end
				end
			end

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
				if @health > 0
					self.updateHealthImage
				else
					self.die!(object.char.player) # Pensando que este implemente o Char
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