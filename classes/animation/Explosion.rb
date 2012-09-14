
require 'gosu'
require 'chingu'

module MadBirds
	module Animation
		class Explosion < Chingu::GameObject
			def initialize(options)
				super(options)
				@animation = Chingu::Animation.new(:file => File.join(GFX, 'explosion_128x128.png'), :loop=>false)
				@animation.frame_names = { :start => (0..6), :end => (33..36) }
			end

			def update
				unless (@destroying)
					super
					if (@animation[:start].index < (@animation[:start].frames.length-1))
						self.image = @animation[:start].next!
					elsif (@animation[:end].index  < (@animation[:end].frames.length-1))
						self.image = @animation[:end].next!
					else
						@destroying = true
						self.destroy!()
					end
				end
			end
		end
	end
end