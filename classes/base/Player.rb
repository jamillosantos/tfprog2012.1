module MadBirds
	module Base
		class Player < Chingu::BasicGameObject
			attr_reader :startTime, :char
			attr_accessor :name, :deaths, :kills

			trait :timer

			def initialize(options)
				super
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

				def startTime
					@startTime
				end
	
				def createChar
					@char = MadBirds::Bird.create(:player=>self, :class=>'redbird')# create(:x=>200, :y=>0, :center_x=>0.5, :center_y=>0.5, :image)
				end

				def charDied!
					after (@parent.rules[:rebirthDelay]) do
						self.createChar
					end
				end
		end

		class Player1 < Player
			def createChar
				super

				@char.input = {
					:s => :shoot,
					:a => :startJump,
					:released_a => :jump,
					:c => :turnLeft,
					:b => :turnRight,
					:holding_c => :move,
					:holding_b => :move,
					:f => :startChangeAngle,
					:v => :startChangeAngle,
					:holding_f => :incAngle,
					:holding_v => :decAngle
				}
			end
		end

		class Player2 < Player
			def createChar
				super

				@char.input = {
					:i => :shoot,
					:o => :startJump,
					:released_o => :jump,
					:left => :turnLeft,
					:right => :turnRight,
					:holding_left => :move,
					:holding_right => :move,
					:up => :startChangeAngle,
					:down => :startChangeAngle,
					:holding_up => :incAngle,
					:holding_down => :decAngle
				}
			end
		end
	end
end
