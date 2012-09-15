
module MadBirds
	module Particles
		class Smoke < Chingu::Particle
			def initialize(options)
				super({
					:image => File.join(GFX, 'smoke1.png'),
					:width => 30,
					:height => 30,
					:scale_rate => +0.01,
					:fade_rate => -10,
					:rotation_rate => +1,
					:mode => :default
				}.merge!(options))
			end

			def update
				if (self.alpha == 0)
					self.destroy!
				else 
					super
				end
			end
		end
	end
end
