
require 'gosu'
require 'chingu'

module MadBirds
	module Animation
		class Explosion < Chingu::GameObject
			def initialize()
				super()
				@animation = Chingu::Animation.new(:file => File.join(GFX, 'explosion1'), )
			end
		end
	end
end