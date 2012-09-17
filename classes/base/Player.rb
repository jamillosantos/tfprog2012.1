module MadBirds
	module Base
		class Player
			attr_reader :startTime
			attr_accessor :name, :deaths, :kills, :char

			def initialize(options)
				self.name = options[:name]
				self.kills = 0
				self.deaths = 0
				@startTime = Gosu::milliseconds
			end

			public
				def name
					@name
				end

				def name=(value)
					@name = value
					@char.name.text = value unless @char.nil?
				end

				def deaths
					@deaths
				end

				def deaths=(value)
					@deaths = value
				end

				def kills
					@kills
				end

				def kills=(value)
					@kills = value
				end

				def char
					@char
				end

				def char=(value)
					@char = value
				end

				def startTime
					@startTime
				end
		end
	end
end
